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

import com.revature.readifined.domain.BookTags;

@Repository
public class BookTagsDAOImpl implements BookTagsDAO{
	
	private SessionFactory sf;
	
	@Autowired
	public void setSessionFactory(SessionFactory sessionFactory) {
		this.sf = sessionFactory;
	}
	
	@Override
	public BookTags getBookTags(int id) {
		Session sess = sf.openSession();
		BookTags bt = sess.get(BookTags.class, id);
		sess.close();
		return bt;
	}

	@Override
	public BookTags getBookTags(int value, String column) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		CriteriaBuilder cb = sess.getCriteriaBuilder();
		CriteriaQuery<BookTags> cq = cb.createQuery(BookTags.class);
		Root<BookTags> rootEntry = cq.from(BookTags.class);
		CriteriaQuery<BookTags> all = cq.select(rootEntry).where(cb.equal(rootEntry.get(column), value));
		TypedQuery<BookTags> allQuery = sess.createQuery(all);
		List<BookTags>list=allQuery.getResultList();
		tx.commit();
		sess.close();
		return list.get(0);
	}

	@Override
	public void saveBookTags(BookTags bt) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		sess.save(bt);
		tx.commit();
		sess.close();
		
	}

	@Override
	public void updateBookTags(BookTags bt) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		sess.update(bt);
		tx.commit();
		sess.close();
		
	}

	@Override
	public void deleteBookTags(BookTags bt) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		sess.delete(bt);
		tx.commit();
		sess.close();
		
	}

}
