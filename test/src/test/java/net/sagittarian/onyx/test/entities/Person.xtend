package net.sagittarian.onyx.test.entities

import com.onyx.persistence.ManagedEntity
import com.onyx.persistence.annotations.Attribute
import com.onyx.persistence.annotations.Entity
import com.onyx.persistence.annotations.Identifier
import com.onyx.persistence.annotations.Relationship
import java.util.Date
import net.sagittarian.onyx.annotations.OnyxFields
import net.sagittarian.onyx.annotations.OnyxJoins
import org.eclipse.xtend.lib.annotations.Accessors

@OnyxFields
@OnyxJoins
@Accessors
@Entity
class Person extends ManagedEntity {

	@Identifier(generator=SEQUENCE)
	@Attribute
	Long id

	@Attribute(nullable=false)
	Date dateCreated = new Date

	@Attribute
	Date dateUpdated

	@Attribute(nullable=false)
	String firstName

	@Attribute
	int age

	@Attribute(nullable=false)
	String lastName

	@Relationship(type=MANY_TO_ONE, inverseClass=Address, inverse='occupants', cascadePolicy=ALL)
	Address address

	override toString() '''«id»: «firstName» «lastName» age: «age»'''

}
