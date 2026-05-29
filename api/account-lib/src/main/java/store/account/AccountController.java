package store.account;

import java.util.List;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

@FeignClient(name = "account", url = "http://account:8080")
public interface AccountController {

    @PostMapping("/account")
    ResponseEntity<Void> create(@RequestBody AccountIn in);

    @GetMapping("/account")
    ResponseEntity<List<AccountOut>> findAll();

    @GetMapping("/account/{id}")
    ResponseEntity<AccountOut> findById(@PathVariable String id);

    @DeleteMapping("/account/{id}")
    ResponseEntity<Void> delete(@PathVariable String id);

    @PostMapping("/account/login")
    ResponseEntity<AccountOut> findByEmailAndPassword(@RequestBody AccountIn in);

    @GetMapping("/account/health-check")
    ResponseEntity<Void> healthCheck();
}
