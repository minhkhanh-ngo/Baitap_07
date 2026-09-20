package vn.iotstar.baitap07.controller.admin;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin")
public class AdminHomeController {

    @GetMapping({"", "/", "/home"})
    public String showDashboard() {
        return "admin/home/dashboard"; 
    }
}