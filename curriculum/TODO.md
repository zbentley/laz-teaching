# Overview: 
This file is a scratchpad of incomplete parts of the curriculum, and serves as a working outline for future units and parts of the course.

## Using Other Code

- Find a hard thing.
- ...for which there is a library.

## Web Technologies

- Identify where different pieces of code are running:
	- Why not expose DB credentials in javascript?
	- What's a CDN?
	- Given a set of specific terms (e.g. “PHP webapp that queries MySQL”).
	- Given a poorly explained scenario (“my online store isn’t working; things aren’t saving to my cart!”)
	- Given a real website, take it apart/reverse engineer it.


## Network Programming

- Basic socket ping/pong program.
- Telnet server.
	- With state. I.e. it remembers something about you (login, for example, or message sequence number) regardless of connect/disconnect.
- Telnet client.
- RPC system (call any method, as if it were local).
	- Why's that not always a great idea.
- HTTP client (browserlike).
- HTTP server.
	- 1. Always returns same HTML.
	- 2. Returns HTML dependent on route.
	- 3. Static file server (.. inj?)
	- 4. Single dynamic behavior: submit form on static page, render values back on dynamic page (no persistence; mem only).
	- 5. Multiple dynamic behavior with shared state (eventual spoiler: this is node)
	- 6. Run PHP pages (none of the cool bits; just echo/templating code).
	- 7. Run your hand-built language from the lang. design section.
- Stateful HTTP server.

## Distributed Systems

- Basic two-generals.
- CAP-ish things, and brewer in general.
- HTTP server with shared state, only now . . . there are two of them
	- Persist state to DB.
	- Simulate DB failure.
	- Alternative: gradual sync.

## Language Design

- String-formatting language.
	- Constructs: interpolate, top-scope global vars . . . IO? If/end (no else)?

## Logging

## System Debugging

- Strace, basically.

## Performance

- Block webserver thread (e.g. huge files).
- Giant requests kill things?
- OOM at least one process.