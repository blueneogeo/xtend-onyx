package nl.kii.onyx.test.entities

import com.onyx.persistence.ManagedEntity
import com.onyx.persistence.annotations.Attribute
import com.onyx.persistence.annotations.Entity
import com.onyx.persistence.annotations.Identifier
import com.onyx.persistence.annotations.Relationship
import java.util.Date
import java.util.List
import nl.kii.onyx.annotations.OnyxFields
import nl.kii.onyx.annotations.OnyxJoins
import org.eclipse.xtend.lib.annotations.Accessors

@OnyxFields
@OnyxJoins
@Accessors
@Entity
class Person extends ManagedEntity {

	@Identifier(generator=SEQUENCE)
	@Attribute
	Integer id

	@Attribute(nullable=false)
	Date dateCreated = new Date

	@Attribute
	Date dateUpdated

	@Attribute(nullable=false)
	String firstName

	@Attribute(nullable=false)
	String lastName

	@Relationship(type=ONE_TO_MANY, inverseClass=Address, inverse='person', cascadePolicy=ALL, fetchPolicy=LAZY)
	List<Address> addresses

	override toString() '''«id»: «firstName» «lastName»'''

}
