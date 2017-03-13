package nl.kii.onyx.annotations

interface Selector<T> {

	def String getName()
	
	def Class<T> getType()

}