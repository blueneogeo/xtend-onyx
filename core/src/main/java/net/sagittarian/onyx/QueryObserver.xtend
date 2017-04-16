package net.sagittarian.onyx

import com.onyx.query.QueryListener
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors(PACKAGE_SETTER)
class QueryObserver<T> {

	(T)=>void itemUpdatedFn
	(T)=>void itemAddedFn
	(T)=>void itemRemovedFn
	=>void stopListeningFn

	@Accessors(PACKAGE_GETTER)	
	val QueryListener<T> listener = new QueryListener<T> {
		
		override onItemAdded(T item) {
			itemAddedFn?.apply(item)
		}
		
		override onItemRemoved(T item) {
			itemRemovedFn.apply(item)
		}
		
		override onItemUpdated(T item) {
			itemUpdatedFn.apply(item)
		}
		
	} 
	
	def void onItemUpdated((T)=>void itemUpdatedFn) {
		this.itemUpdatedFn = itemUpdatedFn 
	}
	
	def void onItemAdded((T)=>void itemAddedFn) {
		this.itemAddedFn = itemAddedFn
	}
	
	def void onItemRemoved((T)=>void itemRemovedFn) {
		this.itemRemovedFn = itemRemovedFn
	}
	
	def void stopObserving() {
		if(stopListeningFn === null) throw new Exception('Unexpected QueryObserver error, we should be able to stop observing, but for some reason the stopListeningFn has not been set by the builder.')
		stopListeningFn.apply	
	}
	
}
