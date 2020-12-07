package io.tblx.demo.api

import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.boot.test.web.client.TestRestTemplate
import org.springframework.boot.web.server.LocalServerPort
import org.springframework.http.HttpStatus

@SpringBootTest(classes = [ApiApplication::class], webEnvironment = SpringBootTest.WebEnvironment.DEFINED_PORT)
class ApiTests {
	@LocalServerPort
	var port: Int = 0

	@Autowired
	lateinit var restTemplate: TestRestTemplate

	@Test
	fun `Hello requires name parameter`() {
		val response = restTemplate.getForEntity("http://localhost:$port/hello", Exception::class.java)
		assertEquals(HttpStatus.BAD_REQUEST, response.statusCode)
	}

	@Test
	fun `Hello returns politely`() {
		val name = "tblx"
		val response = restTemplate.getForEntity("http://localhost:$port/hello?name=$name", String::class.java)
		assertEquals(HttpStatus.OK, response.statusCode)
		assertEquals("Hello, $name!", response.body)
	}
}
