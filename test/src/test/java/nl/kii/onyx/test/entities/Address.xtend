package nl.kii.onyx.test.entities

import com.onyx.persistence.ManagedEntity
import com.onyx.persistence.annotations.Attribute
import com.onyx.persistence.annotations.Entity
import com.onyx.persistence.annotations.Identifier
import com.onyx.persistence.annotations.Relationship
import java.util.Date
import nl.kii.onyx.annotations.OnyxFields
import nl.kii.onyx.annotations.OnyxJoins
import org.eclipse.xtend.lib.annotations.Accessors

@OnyxFields
@OnyxJoins
@Accessors
@Entity
class Address extends ManagedEntity {

	@Identifier(generator=SEQUENCE)
	@Attribute
	Integer id

	@Attribute(nullable=false)
	Date dateCreated = new Date

	@Attribute(nullable=false)
	String street

	@Attribute(nullable=false)
	int houseNr

	@Relationship(type=MANY_TO_ONE, inverseClass=Person, inverse='addresses', cascadePolicy=NONE)
	Person person

	override toString() '''«id»: «street» «houseNr»'''


}
