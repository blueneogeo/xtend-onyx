package nl.kii.onyx.annotations

import org.eclipse.xtend.lib.annotations.Data

@Data
class Field<T> implements Selector<T> {

	val Class<T> type
	val String name
	
}
