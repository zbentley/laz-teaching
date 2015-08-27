package MyClass;

sub makeOne {
	my ( $classname, $value ) = @_;
	"MyClass";
	return bless $classname, { VALUE => $value };
}

sub getValue {
	my $instance = shift;
	return $instance->{VALUE};
}

package main;

# Constructors:
my $v = makeOne MyClass(); # BAD
my $v = makeOne MyClass(1); # BAD
my $v = MyClass->makeOne;
my $v = MyClass->makeOne();
my $v = MyClass->makeOne 1;
my $v = MyClass->makeOne(1);

my $v = MyClass::makeOne("MyClass", 1);

# Getters:
my $b = $v->getValue;
my $b = $v->getValue();
my $b = $v->getValue("foo", "barr", "whatever", $v, { FUCK => "SHIT" });
my $b = MyClass::getValue($v);