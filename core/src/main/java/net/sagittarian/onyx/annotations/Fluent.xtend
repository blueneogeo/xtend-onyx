package net.sagittarian.onyx.annotations

import java.lang.annotation.Target

/**
 * This annotation indictates that the method will return the object it was called on,
 * letting you chain commands together.
 */
@Target(METHOD)
annotation Fluent {
	
}