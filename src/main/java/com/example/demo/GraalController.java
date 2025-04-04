package com.example.demo;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.concurrent.CompletableFuture;

@RestController("/graal")
public class GraalController {

    @GetMapping("/")
    public String graal() {
        return "Hello from GraalVM!";
    }

    @GetMapping("/async")
    public String async() {
        CompletableFuture<String> future1 = CompletableFuture.supplyAsync(() -> {
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            return "Hello from GraalVM after 1 second!";
        });

        CompletableFuture<String> future2 = CompletableFuture.supplyAsync(() -> {
            try {
                Thread.sleep(2000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            return "Hello from GraalVM after 2 seconds!";
        });

        return future1.join() + " " + future2.join();
    }
}
