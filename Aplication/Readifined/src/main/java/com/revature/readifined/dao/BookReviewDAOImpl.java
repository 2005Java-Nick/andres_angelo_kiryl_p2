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
import org.springframework.stereotype.Repository;

import com.revature.readifined.domain.BookReviews;

@Repository
public class BookReviewDAOImpl implements BookReviewDAO {

    private SessionFactory sf;
	
	@Autowired
	public void setSessionFactory(SessionFactory sessionFactory) {
		this.sf = sessionFactory;
	}
	
	@Override
	public BookReviews getBookReview(int id) {
		Session sess = sf.openSession();
		BookReviews br = sess.get(BookReviews.class, id);
		sess.close();
		return br;
	}

	@Override
	public BookReviews getBookReview(int value, String column) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		CriteriaBuilder cb = sess.getCriteriaBuilder();
		CriteriaQuery<BookReviews> cq = cb.createQuery(BookReviews.class);
		Root<BookReviews> rootEntry = cq.from(BookReviews.class);
		CriteriaQuery<BookReviews> all = cq.select(rootEntry).where(cb.equal(rootEntry.get(column), value));
		TypedQuery<BookReviews> allQuery = sess.createQuery(all);
		List<BookReviews>list=allQuery.getResultList();
		tx.commit();
		sess.close();
		return list.get(0);
	}
	
	@Override
	public List<BookReviews> getBookReviews(int value, String column) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		CriteriaBuilder cb = sess.getCriteriaBuilder();
		CriteriaQuery<BookReviews> cq = cb.createQuery(BookReviews.class);
		Root<BookReviews> rootEntry = cq.from(BookReviews.class);
		CriteriaQuery<BookReviews> all = cq.select(rootEntry).where(cb.equal(rootEntry.get(column), value));
		TypedQuery<BookReviews> allQuery = sess.createQuery(all);
		List<BookReviews>list=allQuery.getResultList();
		tx.commit();
		sess.close();
		return list;
	}

	@Override
	public void saveBookReview(BookReviews br) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		sess.save(br);
		tx.commit();
		sess.close();
		
	}

	@Override
	public void updateBookReview(BookReviews br) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		sess.update(br);
		tx.commit();
		sess.close();
		
	}

	@Override
	public void deleteBookReview(BookReviews br) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		sess.delete(br);
		tx.commit();
		sess.close();
		
	}

}
