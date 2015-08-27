#!/usr/bin/python

class MyThing:

	value = None
	def __init__(self, value):
		self.value = value

	def getValue(self):
		return self.value

a = [ MyThing(num) for num in (1, 3, 2, 5, 4) ]



############ Begin Sorting #######

# Must be at head of list
val = 5 

nothing_changes = 0
first_goes_after_last = 1
last_goes_after_first = -1


def myFunction(first, last):
	first = first.getValue()
	last = last.getValue()


	if last == val:
		return first_goes_after_last
	if first == val:
		return last_goes_after_first
#	if last < first:
	#	return -1

	if first == last:
		return nothing_changes

	if first < last:
		return last_goes_after_first

	if first > last:
		return first_goes_after_last



a = sorted(a, myFunction)


####### End Sorting #######
print "Results go here:"
print [ obj.getValue() for obj in a ]