package com.revature.readifined.dao;

import java.util.List;

import javax.persistence.TypedQuery;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.revature.readifined.domain.Review;
import com.revature.readifined.domain.Review;
@Component
public class ReviewDAOImpl implements ReviewDAO {

    private SessionFactory sf;
	
	@Autowired
	public void setSessionFactory(SessionFactory sessionFactory) {
		this.sf = sessionFactory;
	}
	
	@Override
	public Review getReview(int id) {
		Session sess = sf.openSession();
		Review r = sess.get(Review.class, id);
		sess.close();
		return r;
	}

	@Override
	public Review getReview(String value, String column) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		CriteriaBuilder cb = sess.getCriteriaBuilder();
		CriteriaQuery<Review> cq = cb.createQuery(Review.class);
		Root<Review> rootEntry = cq.from(Review.class);
		CriteriaQuery<Review> all = cq.select(rootEntry).where(cb.equal(rootEntry.get(column), value));
		TypedQuery<Review> allQuery = sess.createQuery(all);
		List<Review>list=allQuery.getResultList();
		tx.commit();
		sess.close();
		return list.get(0);
	}
	
	@Override
	public Review getReview(int value, String column) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		CriteriaBuilder cb = sess.getCriteriaBuilder();
		CriteriaQuery<Review> cq = cb.createQuery(Review.class);
		Root<Review> rootEntry = cq.from(Review.class);
		CriteriaQuery<Review> all = cq.select(rootEntry).where(cb.equal(rootEntry.get(column), value));
		TypedQuery<Review> allQuery = sess.createQuery(all);
		List<Review>list=allQuery.getResultList();
		tx.commit();
		sess.close();
		return list.get(0);
	}

	@Override
	public void saveReview(Review r) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		sess.save(r);
		tx.commit();
		sess.close();
		
	}

	@Override
	public void updateReview(Review r) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		sess.update(r);
		tx.commit();
		sess.close();
		
	}

	@Override
	public void deleteReview(Review r) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		sess.delete(r);
		tx.commit();
		sess.close();
		
	}

}
