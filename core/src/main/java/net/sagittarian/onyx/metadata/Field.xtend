package net.sagittarian.onyx.metadata

import org.eclipse.xtend.lib.annotations.Data

@Data
class Field<T> implements Selector<T> {

	val Class<T> type
	val String name
	
}
