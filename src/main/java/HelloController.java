package com.example.demo.controller;

import com.example.demo.service.GreetingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api")
public class HelloController {

  @Autowired
  private GreetingService greetingService;

  @GetMapping("/hello")
  public String sayHello(@RequestParam(defaultValue = "World") String name) {
    return greetingService.greet(name);
  }
}