package net.sagittarian.onyx.metadata

interface Selector<T> {

	def String getName()
	
	def Class<T> getType()

}