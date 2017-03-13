package nl.kii.onyx.annotations

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors(PUBLIC_GETTER)
class OneToManyRelationship<ONE, MANY> {

	String oneField
	Class<ONE> oneType
	String manyField
	Class<MANY> manyType

	new(Class<ONE> oneType, String oneField, Class<MANY> manyType, String manyField) {
		this.oneType = oneType
		this.oneField = oneField
		this.manyType = manyType
		this.manyField = manyField
	}
	
}
