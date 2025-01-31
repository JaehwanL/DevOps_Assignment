package jaehwan.helloworld;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
public class HelloworldApplication {

  @RequestMapping("/")
  public String home() {
    return "Hello Jaehwan World";
  }

  public static void main(String[] args) {
    SpringApplication.run(HelloworldApplication.class, args);
  }

}
