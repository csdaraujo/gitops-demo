package io.tblx.demo.api

import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController

@RestController
class ApiController {
	@GetMapping("/hello")
	fun getHello(@RequestParam("name", required = true) name: String): String {
		return "Hello, $name!"
	}

	@GetMapping("/goodbye")
	fun getGoodbye(@RequestParam("name", required = true) name: String): String {
		return "See ya, $name :(/n"
	}
}
