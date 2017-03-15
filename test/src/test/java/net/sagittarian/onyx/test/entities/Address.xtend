package net.sagittarian.onyx.test.entities

import com.onyx.persistence.ManagedEntity
import com.onyx.persistence.annotations.Attribute
import com.onyx.persistence.annotations.Entity
import com.onyx.persistence.annotations.Identifier
import com.onyx.persistence.annotations.Relationship
import java.util.List
import net.sagittarian.onyx.annotations.OnyxFields
import net.sagittarian.onyx.annotations.OnyxJoins
import org.eclipse.xtend.lib.annotations.Accessors

@OnyxFields
@OnyxJoins
@Accessors
@Entity
class Address extends ManagedEntity {

	@Identifier(generator=SEQUENCE)
	@Attribute
	Long id

	@Attribute(nullable=false)
	String street

	@Attribute(nullable=false)
	int houseNr

	@Relationship(type=ONE_TO_MANY, inverseClass=Person, inverse='address', cascadePolicy=ALL, fetchPolicy=LAZY)
	List<Person> occupants

	override toString() '''«id»: «street» «houseNr», occupants: «occupants?.map[toString]»'''

}
