package com.revature.readifined.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.revature.readifined.domain.Session;
import com.revature.readifined.services.AuthorizationService;
import com.revature.readifined.services.ReviewServiceImpl;

@Controller
public class ReviewController {

private ReviewServiceImpl reviewServiceImpl;
	
	@Autowired
	public void setLoginService (ReviewServiceImpl reviewServiceImpl)
	{
		this.reviewServiceImpl=reviewServiceImpl;
	}
	@RequestMapping(path = "/submitReview", method = RequestMethod.POST)
	@ResponseBody
	public String getlogin(@RequestParam(name = "session", required = false) String sess,
							@RequestParam(name = "review", required = true) String review,
							@RequestParam(name = "rating", required = true) String rating,
							@RequestParam(name = "bookid", required = true) String bookId) {
		System.out.println("Submited Review");
		sess=sess.replace(" ", "+");
		if (sess==null)
		{
			return ("Error inserting review please sign in.");
		}
		else
		{	String res=reviewServiceImpl.insertReview(Integer.parseInt(bookId), sess, review, Integer.parseInt(rating));
			System.out.println(res);
			return res;
		}
	}
	
}
