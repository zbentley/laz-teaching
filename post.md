# Using HAProxy as a Session Authenticator and Cache

I learned a bit about [HAProxy](http://www.haproxy.org/) the other day, after being asked to solve a somewhat strange problem: I needed to manage authenticated sessions across two web application backend technologies, each of which was written in a different language and did not communicate with a common session store. In the process, I gained a lot of useful info, so I'll write it up here so others might benefit.

**Note:** I am a novice user of HAProxy, and there are *very likely* better ways of doing everything I discuss in this post. Do your research.

## Background/Context

### Acronyms:
- **LB**: Load Balancer/Proxy. Usually HAProxy in the examples; a legacy load balancer if specified.
- **WS**: WebSocket. The service I was trying to make a new proxying infrastructure for. Could just as well be "Web Service" or any other exposed thing.
- **SPOF**:  [Single Point of Failure](https://en.wikipedia.org/wiki/Single_point_of_failure).
- **ACL**: [HAProxy Access Control List](https://cbonte.github.io/haproxy-dconv/configuration-1.6.html#7). A named "if"-check in the proxy, basically. Multiple ACLs can be set as conditions for various proxy actions. There are also "side effect ACLs", which are ACLs that always return true, and change some internal HAProxy state when they are evaluated.

I work on a monolithic, single-threaded web application that runs inside Apache. The server-side code that generates responses is still extremely intensive in terms of both CPU utilization, wall-clock time, and memory growth during response generation. 

As a result, the Apache instances that serve application pages are carefully limited in number. The hardware on which the Apache instances run is also constrained due to space and cost. The application serves up to hundreds of thousands of requests per minute. All of the Apache instances are identical; none are dedicated to serving a particular kind of request. That's regrettable, but unlikely to change.

All of this results in a very important need to *not add traffic to the apaches that does not directly serve application pages* and to *not add traffic that blocks a precious Apache process*. Any new HTTP request types need to be both fast and limited in number.

All requests to the monolith go through a hand-configured, proprietary load balancer. It works well for traditional application logic, but the addition of new rules and behavior to it is done only with the greatest reluctance, as even seemingly-isolated changes have historically caused serious issues.

## The Ask

Users of the pages served by the monolith want something like push notifications. More specifically: pages, after they have rendered, should update, via JavaScript within a second or two in response to server-side events that get pushed to them.

Initially, we attempted to use [long-polling](https://en.wikipedia.org/wiki/Push_technology#Long_polling) to achieve this. However, as soon as long-polling was enabled in significant volume, issues occurred. Since each long-polling process stayed active for a long time, the net number of available forks was reduced, and since each long-polling process consumed almost no resources while waiting for data, it damaged the accuracy of the  the (carefully tuned over many years) calculus used to allocate processes based on possible memory and CPU use onto each web server host.

After that failed experiment, we used traditional polling (JavaScript served to the client made AJAX requests periodically for a page that provided current data). This worked for awhile, but as volume was ramped up, the net "chatter" of small requests increased the net load and process utilization across our Apache instances considerably. Well before 50% of planned capacity ramp-up was complete, our Apache instances frequently became too saturated with small polling requests to quickly respond to more urgent page requests. Also, most of the polling requests were unnecessary, as they just returned responses indicating that no changes had occurred since the last polling period.

Many other, more powerful means of pushing notifications to clients exist. I strongly recommend the excellent answer to  [this StackOverflow question](http://stackoverflow.com/questions/11077857/what-are-long-polling-websockets-server-sent-events-sse-and-comet) for a quick overview. 

After reviewing available options, we decided to do the following:
- Have client pages connect via [WebSockets over socket.io](http://socket.io/) to a notification service.
- Start a set of totally separate server processes on separate hardware to respond to WebSocket connections. These servers would be a totally separate software platform from the rest of our app.

All pretty standard stuff so far. Many people have done the above successfully.

## The Problem

The custom WebSocket servers needed to be secured with the session information of the served pages. In short, we didn't want clients to be able to open WebSocket connections if they aren't authenticated on a session in the main application. A few constraints complicated what would have been an otherwise simple problem:
- The main application did all of its session handling internally, via cookies; the pre-existing proprietary load balancer only handled session stickiness, and it did that very crudely.
- The main application had previously only handled one type of requests associated with a session (plain old single-page HTTP requests sent to customized Apache servers via the legacy LB), so most of the session-handling code was very tightly integrated with Apache and the server-side legacy code.
- There was no separate authorization/session-management middleware process, or even separate session-management code that could be generalized or called from a new platform.
- Any proposal of sweeping changes to the legacy load balancer met with substantial resistance, as it was considered to be a fragile SPOF that should not be given new responsibilities.

In light of the above, I decided to look into creating a new load balancer for client WebSocket connections. The only modification to the legacy LB would be to pass WS requests through to the new LB, which assuaged concerns about stability. Even if the new LB proved cumbersome to maintain in addition to the old one in the long run, if the new one worked well, I reasoned, perhaps that would incentivize similar functionality being added to the old LB so that it could operate as a one-stop-shop for all routing and session persistence.

But how to ensure that WebSocket clients couldn't open unauthorized sessions to the new servers? That's what I was tasked with solving.

## Initial Idea: Manual Session Management

First, I considered the simplest approach: doing all session management at the application layer, and adding a session-persistence database to the application. This attempt didn't do anything with load balancers (don't worry: they'll become relevant later on). It would look like this:

- When sessions were created via legacy code, a session cookie or identifier would be stored in the session database.
- All WebSocket connections would be opened with the session cookie sent to the client from the legacy application, and the WS server processes would authenticate that cookie against the session database in order to determine whether to handle or reject a request.

This is standard practice, but has a few drawbacks:
- A separate session database has to be maintained. Plenty of solutions exist for this, but it's still added complexity--code in the WS servers has to be added to inspect the session store and coordinate info from it with incoming request contents.
- Expirations, manual log-outs, and administrative invaliations also have to be reliably and securely handled somehow. Again, this is common, but more code/failure surface to worry about.
- The individual server processes (the WebSocket servers, in this case) are in charge of handling *all* requests, even invalid ones. This increases both complexity and capacity requirements: the added load of rejecting invalid sessions is non-trivial at high volume, and it is also a potential DoS vector (attackers pumping massive numbers of invalid session requests into the system).

All of the above seemed crude and unnecessary. Given that I was already using a separate LB/proxy service for the new WebSocket servers, I started investigating whether or not I could use that to arbitrate sessions.

## HAProxy to the Rescue

Using [HAProxy](http://www.haproxy.org/) as the LB and session management solution turned out to be easy. The request lifecycle looked like:

1. Client logs in to the legacy application, or requests a page in an authenticated session.
2. Server-side code rendering the legacy page tells HAProxy to store session info for that page in a table.
3. Client receives response and attempts to open WebSocket connection. 
4. HAProxy checks if the client's request is already in the session table; if so, request is proxied to the WS servers. If not, HAProxy rejects the request before it hits the WS servers.

This had the benefits of centralizing session management, load balancing, and DoS protection in one place. It also utilizes HAProxy's internal session store (called [stick-tables](https://cbonte.github.io/haproxy-dconv/configuration-1.6.html#4-stick-table))  for session validation, which eliminated the requirement for a secondary session store or source of truth.

To prove that this worked properly, I needed a simple testing environment.

## Test Setup

### 1. Netcat Backend
To test this behavior, I started a simple [netcat one-line web server](http://stackoverflow.com/questions/16640054/minimal-web-server-using-netcat) that would always return a 200 status and the word `SUCCESS` as the response body on port 8080: 

```bash
zb@mac:~ while true; do echo -e "HTTP/1.1 200 OK\n\nSUCCESS" | nc -l 8080; done
```

It should run forever.

### 2. HAProxy Basic Config
I configured HAProxy to pass requests through to it  with the following `haproxy.conf` (the full config with global/default boilerplate is at the end of this post):

```python
global
  # Enable proxy internal state-inspection socket; will be useful for viewing stick table contents.
  stats socket /tmp/haproxy.sock mode 600 level admin

frontend websockets-external
  bind *:8001
  default_backend websockets2

backend websockets1
  balance roundrobin
  server localhost_8080 localhost:8080
```

As it says, the `global` section enables the proxy debugging socket. With that enabled, I can use [`socat`](http://linux.die.net/man/1/socat) (installable via Homebrew on OSX) to inspect the state of my stick tables, e.g. `echo "show table session_admin" | socat stdio /tmp/haproxy.sock`. That will become very relevant later on.

Other than that, is just proxies requests on port 8000 to my netcat-based backend running on port 8080. Not very interesting.

### 3. Basic Test

First, I started the LB:

```bash
haproxy -f haproxy.conf -V -d
```

Then I made sure I could access the server directly as well as through the proxy:

```bash
zb@mac:~ curl localhost:8080
SUCCESS

zb@mac:~ curl localhost:8000
SUCCESS
```

## Session Tracking via Counters

Now to make things interesting. I configured HAProxy to increment one of its in-memory "General Purpose Counters" (`gpc*` trackers) whenever a "session create" request came in. Session-creation requests were identified by a special, shared-secret "admin" cookie, which would (in production) be supplied from the server rendering the legacy login/session-update page to the WebSocket server without ever going to the client. Comments are added in the config below to explain what each line does:

```python
frontend www
  bind *:8000
  default_backend main_backend

backend main_backend
  # Create a session stickiness table mapping 32-bit strings to backend server
  # IDs and counter integers.
  # It can have a million rows, and will expire sessions after 5 seconds of
  # inactivity.
  stick-table type string len 32 size 1m expire 5s store gpc0
  # Enable tracking of session counters so we can update the counter fields in
  # the table.
  http-request track-sc0 req.cook(SESSION_COOKIE)

  # Check if incoming requests have a secret, internal-use-only cookie.
  acl session_admin req.cook(SECRET_COOKIE) eq SUPER_SECRET
  # Increment the counter in the stick table for a given request.
  acl increment_counter sc0_inc_gpc0 -m found
  # Check if there is a non-zero counter in the stick table for a given request.
  acl authorized sc0_get_gpc0 gt 0

  # If a request has the secret admin cookie, store a session-stickiness entry
  # for requests with a given value for the non-admin (session, non-admin)
  # cookie, and increment the internal counter for that cookie.
  stick on req.cook(SESSION_COOKIE) if session_admin increment_counter
  # Ensure that non-admin requests for a given session cookie are pinned to a
  # particular backend server for their lifetime.
  stick match req.cook(SESSION_COOKIE) if authorized

  # Send 403s for requests that are neither pre-authorized (admin-created
  # counter has already been incremented) nor session-admin type.
  http-request deny unless authorized || session_admin

  balance roundrobin
  server localhost_8080 localhost:8080
  # More servers could go here if we wanted to load-balance between multiple WS endpoints.
  ```

OK, that seems reasonable. Let's test it (don't forget to restart HAProxy!):

```bash
zb@mac:~ curl -b SESSION_COOKIE=TEST localhost:8000
<html><body><h1>403 Forbidden</h1>
Request forbidden by administrative rules.
</body></html>
```

Unauthenticated requests are forbidden; that looks right. Now let's try installing a session cookie via a shared-secret-authenticated "admin" request:

```bash
zb@mac:~ curl -b "SECRET_COOKIE=SUPER_SECRET; SESSION_COOKIE=TEST" localhost:8000
SUCCESS
```

That worked. Is the installed session usable?
```bash
zb@mac:~ curl -b SESSION_COOKIE=TEST localhost:8000
SUCCESS
```

Awesome, it looks like it's working. Does session expiration (set to 5 seconds via the HAProxy config) work? Let's see:

```bash
zb@mac:~ curl -b "SECRET_COOKIE=SUPER_SECRET; SESSION_COOKIE=TEST" localhost:8000
SUCCESS

zb@mac:~ curl -b SESSION_COOKIE=TEST localhost:8000
SUCCESS

zb@mac:~ sleep 5 && curl -b SESSION_COOKIE=TEST localhost:8000
<html><body><h1>403 Forbidden</h1>
Request forbidden by administrative rules.
</body></html>
```

When I first finished the above, I thought I was done--and I very nearly was. **However, there is a subtle issue and security risk.** All sessions should expire after 5 seconds in the above example, and they *look* like they do. However, consider the following:

```bash
zb@mac:~ curl -b "SECRET_COOKIE=SUPER_SECRET; SESSION_COOKIE=TEST" localhost:8000
SUCCESS

zb@mac:~ curl -b SESSION_COOKIE=TEST localhost:8000
SUCCESS

# Installed session should still be usable 4 seconds after creation.
zb@mac:~ sleep 4 && curl -b SESSION_COOKIE=TEST localhost:8000
SUCCESS

# Installed session should definitely *NOT* be usable 8 seconds after it was authorized.
zb@mac:~ sleep 4 && curl -b SESSION_COOKIE=TEST localhost:8000
SUCCESS
```

WTF? Sessions don't seem to be expiring properly. It turns out that the act of retrieving a GPC (`sc0_get_gpc0`) itself *creates* an entry in the stick table, just like [autovivification in Perl](http://www.sysarch.com/Perl/autoviv.txt). However, I'm not terribly sure about the reasons for this; it might be an issue with the application order of `stick match` rules or something else.

Either way, the behavior means that client requests made on a period exhibit a keep-alive-like behavior and persist the session in the LB. This might be desirable if I was using HAProxy as the sole source-of-truth for session information, but it's definitely *not* wanted while using it as a delegate/secondary session store; it could enable users to keep WS connections usable indefinitely, even after the legacy application logged a user out. Not cool.

I set to work seeing if I could make a better solution that prevented the above, and, ideally, also simplified the session-tracking process. I also still needed to make force-logout (destroying a session via the legacy app before its expiration timeout in WebSocket-land, e.g. due to user-log-out actions or an administrative session termination of a troublesome user) work.

## Solution: Separate Authorization/Stickiness Tables with Forced Invalidation

In my initial attempt, it turned out that I had made a few mistakes:
- I was using the `gpc*` fields to stand for a boolean value, which I could just as well have used a single-integer `gpt*` tag field for.
- I was manipulating session tables using the `sc_`-prefixed functions, most/all of which exhibit the confusing autovivification behavior that caused the issue with the second attempt.
- I had written confusing rules because I was trying to manage requests to the session administration system and the client authentication system in the same config area (backend).

Eventually, I arrived at the following solution. It times out authenticated sessions properly, supports early invalidation/revalidation of existing sessions, session stickiness, proxy-only rejection, and keeps session tables from getting bloated by erroneous request spam:

```python
frontend www

  bind *:8000

  # Route requests beginning with /admin to the session administration section.
  # This is not actually a separate backend; just a separate config section
  # used to deliniate between types of requests to the same servers. It also
  # has the important side effect of allowing the creation of a separate stick
  # table.
  acl is_session_admin url_beg /admin

  use_backend session_admin if is_session_admin

  default_backend main_backend

backend session_admin

  # This table only stores session authoirization info. There are two
  # bits of useful information in this table: whether or not it contains a
  # given session cookie, and whether or not that session cookie has been force-
  # -invalidated via an /admin/invalidate request.
  stick-table type string size 1m expire 5s store gpt0

  # Make sure the admin secret key is valid.
  acl authorized_session_admin req.cook(SECRET_COOKIE) eq SUPER_SECRET

  # Check for the presence of the session update-or-add URL.
  acl is_session_update url_end /admin/update

  # Check for the presence of the session force-close URL.
  acl is_session_close url_end /admin/invalidate

  # Check if a session exists in the table, and has its GPT counter set to 1,
  # indicating that the session has not been force-invalidated.
  acl session_open req.cook(SESSION_COOKIE),table_gpt0(session_admin) eq 1

  # Enable tracking of session counters so we can update the GPT field in the
  # stick table. Tracking shoud not be enabled if a request is for the forced
  # invalidation of a request on a session that no longer exists; this prevents
  # bloat on the session_admin table in the event that processes continue
  # sending multiple session-invalidation requests for the same cookie.
  http-request track-sc0 req.cook(SESSION_COOKIE) unless authorized_session_admin is_session_close !session_open

  # Reject admin requests that don't have the correct secret cookie.
  http-request deny if !authorized_session_admin

  # When session-add requests are received and authorized, install a sticky
  # session for them in the session table by setting the GPT field to 0.
  # The presence of the session cookie as a key in the session_admin table
  # can be used by non-admin requests to determine whether a session cookie is
  # valid or not. Those requests must also check the GPT value to make sure
  # that a session has not been invalidated.
  http-request sc-set-gpt0 1 if authorized_session_admin is_session_update

  # When session-invalidation requests are received and authorized, install a
  # sticky session for them in the session table, and also mark that session
  # as invalid so that it cannot be used for the remainder of its life. If
  # the session has already been removed from the session authorization table,
  # don't mark it as invalid (prevents accumulation of invalid-session rows in
  # the table if things send redundant invalidation requests).
  http-request sc-set-gpt0 0 if authorized_session_admin session_open is_session_close

  # Since there's no backend server, admin requests will always 503.

backend main_backend

  # This table only stores stickiness routes.
  # The actual lifetime of a request in this table is 2X the expire time, since
  # a client could make a request that updated the stickiness table right as the
  # session cache expired that client's session. Expiration is not strictly
  # necessary here.
  stick-table type string size 1m expire 5s

  # Where the magic happens: check the existence of the current session in the
  # session_admin table, and ensure that it has not been force-invalidated.
  acl authorized req.cook(SESSION_COOKIE),table_gpt0(session_admin) eq 1

  # Reject unauthorized requests.
  http-request deny unless authorized

  # Install real session stickiness for authorized requests.
  stick on req.cook(SESSION_COOKIE) if authorized

  # Proxy requests to our test server.
  balance roundrobin

  server localhost_8080 localhost:8080
```

### Detailed Explanation

There are a bunch of moving parts there. Let's walk through them:

First, requests come in to the frontend, and are routed to the session-administration backend if they are for URLs that start with `/admin`. A separate backend must be used to maintain the session administration stick table, and, while all the other session administration logic could technically live in the same backend, it increases readability to put it in the same one as the other table. 

#### Session Administration Backend

1. Requests are rejected if they do not contain a secret (internal) cookie matching a value that is known between the servers supplying the session-persistence requests to HAProxy and HAProxy itself, but is never supplied to clients.
2. Requests arriving in the `session_admin` backend have custom stick-table tracking enabled via the `http-request track-sc0 req.cook(SESSION_COOKIE) unless authorized_session_admin is_session_close !session_open` directive. This stores the session (public) cookies of requests in the `session_admin` stick table, unless a request is for the forced invalidation of an already-closed session, in which case it is not handled for stickiness.
3. If a request is for the session add-or-update (updating resets the expiration time of the session) URL, its `gpt0` tag variable is set to `1` (session valid) in the `session_admin` stick table, using the session cookie as the key.
4. If a request is for the session-invalidate URL, its `gpt0` tag variable is set to `0` (session valid) in the `session_admin` stick table, using the session cookie as the key.
	- This update increases the duration of time records for a cookie stay in the stick table, but it also allows them to be invalidated before their record expires via the table expiration time (5 seconds in the above example).
5. All requests to the `session_admin` backend will result in HAProxy sending a 503 error back, since no servers are configured in the backend. That's fine; it's the update of HAProxy's internal state during request processing that we care about.
	- If you don't like getting error codes in successful cases, you could hack around that with a forced-200-response HTTP file as suggested in [this link](https://abesto.net/serving-error-pages-from-haproxy/).

#### Main Backend

1. Requests that *don't* go to the admin backend go to the `main_backend` backend. There, a request is rejected unless the ACL `acl authorized req.cook(SESSION_COOKIE),table_gpt0(session_admin) eq 1` is satisfied.
2. In that ACL, the session cookie is extracted from the request and fed into `table_gpt0(session_admin)`, which looks it up in the `session_admin` backend's stick table and returns the `gpt0` value for the session cookie stored in that table. This does one of three things:
	- If the session cookie *does not exist* in the `session_admin` table, 0 is returned.
	- If the session cookie *exists, but has a `gpt0` value of something other than 1*, the session is detected as remotely invalidated, and 0 is returned.
	- If the session cookie exists and has a `gpt0` value of 1, 1 is returned.
3. If a request gets `1` back from the `gpt0` check on the `session_admin` table, it is handled normally: it is pinned to a server via the session-stickiness table of the `main_backend` backend, and is routed and served.

Most of the complexity in the above rules is due to the manipulation of `gpt0` as a dual-purpose tracker of session presence and force-invalidation. If all I cared about was session presence, and things didn't need to be force-invalidated in the LB itself, basic `stick store-request` rules could be used instead of `gpt0` tracking, and the main backend could just check for presence using an ACL like `req.cook(SESSION_COOKIE),in_table(session_admin) -m bool`.

### Testing

So, does it work? Let's see. 

First, let's test basic session authorization:

```bash
zb@mac:~ curl -sb SESSION_COOKIE=TEST localhost:8000
<html><body><h1>403 Forbidden</h1>
Request forbidden by administrative rules.
</body></html>

zb@mac:~ curl -sb "SECRET_COOKIE=SUPER_SECRET; SESSION_COOKIE=TEST" localhost:8000/admin/update
<html><body><h1>503 Service Unavailable</h1>
No server is available to handle this request.
</body></html>

zb@mac:~ curl -b SESSION_COOKIE=TEST localhost:8000
SUCCESS
```

Session installation works. Because our test is limited, successful admin requests will return 503s. That is expected.

Good so far, but I've learned not to get cocky from the previous attempts. Does session expiration work? Let's see:

```bash
zb@mac:~ curl -b "SECRET_COOKIE=SUPER_SECRET; SESSION_COOKIE=TEST" localhost:8000/admin/update
<html><body><h1>503 Service Unavailable</h1>
No server is available to handle this request.
</body></html>

zb@mac:~ curl -b SESSION_COOKIE=TEST localhost:8000
SUCCESS

zb@mac:~ sleep 5 && curl -b SESSION_COOKIE=TEST localhost:8000
<html><body><h1>403 Forbidden</h1>
Request forbidden by administrative rules.
</body></html>
```

Still good. Now let's test the case that tripped us up before, with session expiration and keep-alives:

```bash
zb@mac:~ curl -b "SECRET_COOKIE=SUPER_SECRET; SESSION_COOKIE=TEST" localhost:8000/admin/update
<html><body><h1>503 Service Unavailable</h1>
No server is available to handle this request.
</body></html>

zb@mac:~ sleep 4 && curl -b SESSION_COOKIE=TEST localhost:8000
SUCCESS

zb@mac:~ sleep 4 && curl -b SESSION_COOKIE=TEST localhost:8000
<html><body><h1>403 Forbidden</h1>
Request forbidden by administrative rules.
</body></html>
```

Awesome. How about session force-invalidation (e.g. a user clicks the "logout" button, or an administrator remotely terminates another user's session due to sketchy activity)?

```bash
zb@mac:~ curl -b "SECRET_COOKIE=SUPER_SECRET; SESSION_COOKIE=TEST" localhost:8000/admin/update
<html><body><h1>503 Service Unavailable</h1>
No server is available to handle this request.
</body></html>

zb@mac:~ curl -b SESSION_COOKIE=TEST localhost:8000
SUCCESS

# Invalidate the session with the TEST session cookie:
zb@mac:~ curl -b "SECRET_COOKIE=SUPER_SECRET; SESSION_COOKIE=TEST" localhost:8000/admin/invalidate
<html><body><h1>503 Service Unavailable</h1>
No server is available to handle this request.
</body></html>

zb@mac:~ curl -b SESSION_COOKIE=TEST localhost:8000
<html><body><h1>403 Forbidden</h1>
Request forbidden by administrative rules.
</body></html>
```

The above commands need to be run pretty quickly, otherwise you might get false-positive results due to sessions timing out after 5 seconds.

But it works! This looks like the beginnings of reasonable prototype for keeping HAProxy in sync with an external session management system. I'll update again with production results if we end up using it.

### Additional Info
- I used HAProxy 1.6 for all of my testing. The documentation is available [here](https://cbonte.github.io/haproxy-dconv/configuration-1.5.html).
- The secret administrative cookie can change often/constantly. HAProxy supports reading values from files or other persistent stores (and efficiently watching those sources for changes), so the shared secret could be continuously updated. It could even be generated by HAProxy itself (which supports cookie injection) and sent back to the legacy application server after the first session-creation request.
- The specific WebSocket backend server technology used (and the fact that WebSockets are the protocol being handled) isn't really important for this discussion; I may code up an example Node.JS WebSocket server for any follow-up posts I write, but it could just as well be any other protocol/language.
- I could pass `session_admin` requests to the same backend servers as the `main_backend` requests if I wanted--all I'd have to do is add the `balance`/`server` lines to the `session_admin` backend instead of the `errorfile` directive. That way, if the WebSocket servers wanted to know about session creation/invalidation events, they could. 
	- If I did this, I would also add a `stick on` line to the `session_admin` backend that bound session administration sessions to the same server as client sessions, e.g. `stick on req.cook(SESSION_COOKIE) table main_backend if authorized_session_admin`.
- On the other hand, HTTP is not necessary for the admin. Simple TCP sockets/broadcast events with no replies could be used to blast out session-creation and session-invalidation requests. The legacy application pages sending the events don't even need to wait for them, and, if HAProxy is properly configured, it doesn't have to spend the time sending replies to peers that don't care, either.
- In production, the `authorized_session_admin` ACL should probably also make sure session-modification requests come in over the internal network or are otherwise secured, but for testing on a single computer, using the shared secret cookie alone will suffice.
- The *actual* session-to-server stickiness table (not the one we repurpose for session authorization) is totally optional. If your backends are stateless, there's no need to manage stickiness at all; any request can be handled by any server.
- None of the tricks used in the above configs will work perfectly if HAProxy is in multiple-process (`nbproc` > 1) mode. They could potentially still be used, but a lot more trickery would be required. At that point, I'd suggest looking into a real, separate session storage mechanism.
- I also highly recommend reading [this excellent blog post](http://blog.serverfault.com/2010/08/26/1016491873/) by the ServerFault folks about using HAProxy as a rate limiter and defense mechanism.

### Full Config

Here's the full HAProxy config used in the final solution:

```python
global
  stats socket /tmp/haproxy.sock mode 600 level admin

defaults
  timeout connect 1000
  timeout client 1000
  timeout server 1000

frontend www

  bind *:8000

  # Route requests beginning with /admin to the session administration section.
  # This is not actually a separate backend; just a separate config section
  # used to deliniate between types of requests to the same servers. It also
  # has the important side effect of allowing the creation of a separate stick
  # table.
  acl is_session_admin url_beg /admin

  use_backend session_admin if is_session_admin

  default_backend main_backend

backend session_admin

  # This table only stores session authoirization info. There are two
  # bits of useful information in this table: whether or not it contains a
  # given session cookie, and whether or not that session cookie has been force-
  # -invalidated via an /admin/close request.
  stick-table type string size 1m expire 5s store gpt0

  # Make sure the admin secret key is valid.
  acl authorized_session_admin req.cook(SECRET_COOKIE) eq SUPER_SECRET

  # Check for the presence of the session update-or-add URL.
  acl is_session_update url_end /admin/update

  # Check for the presence of the session force-close URL.
  acl is_session_close url_end /admin/invalidate

  # Check if a session exists in the table, and has its GPT counter set to 1,
  # indicating that the session has not been force-invalidated.
  acl session_open req.cook(SESSION_COOKIE),table_gpt0(session_admin) eq 1

  # Reject admin requests that don't have the correct secret cookie.
  http-request deny if !authorized_session_admin

  # Enable tracking of session counters so we can update the GPT field in the
  # stick table. Tracking shoud not be enabled if a request is for the forced
  # invalidation of a request on a session that no longer exists; this prevents
  # bloat on the session_admin table in the event that processes continue
  # sending multiple session-invalidation requests for the same cookie.
  http-request track-sc0 req.cook(SESSION_COOKIE) unless authorized_session_admin is_session_close !session_open

  # When session-add requests are received and authorized, install a sticky
  # session for them in the session table by setting the GPT field to 0.
  # The presence of the session cookie as a key in the session_admin table
  # can be used by non-admin requests to determine whether a session cookie is
  # valid or not. Those requests must also check the GPT value to make sure
  # that a session has not been invalidated.
  http-request sc-set-gpt0 1 if authorized_session_admin is_session_update

  # When session-invalidation requests are received and authorized, install a
  # sticky session for them in the session table, and also mark that session
  # as invalid so that it cannot be used for the remainder of its life. If
  # the session has already been removed from the session authorization table,
  # don't mark it as invalid (prevents accumulation of invalid-session rows in
  # the table if things send redundant invalidation requests).
  http-request sc-set-gpt0 0 if authorized_session_admin session_open is_session_close

backend main_backend
  # This table only stores stickiness routes.
  # The actual lifetime of a request in this table is 2X the expire time, since
  # a client could make a request that updated the stickiness table right as the
  # session cache expired that client's session. Expiration is not strictly
  # necessary here.
  stick-table type string size 1m expire 5s

  # Where the magic happens: check the existence of the current session in the
  # session_admin table, and ensure that it has not been force-invalidated.
  acl authorized req.cook(SESSION_COOKIE),table_gpt0(session_admin) eq 1

  # Reject unauthorized requests.
  http-request deny unless authorized

  # Install session stickiness for authorized requests.
  stick on req.cook(SESSION_COOKIE) if authorized

  # Proxy requests to our test server.
  balance roundrobin

  server localhost_8080 localhost:8080
```

Thanks for reading!
