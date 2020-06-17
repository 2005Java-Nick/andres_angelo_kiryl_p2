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

import com.revature.readifined.domain.Book;
@Component
public class BookDAOImpl implements BookDAO {
	
	private SessionFactory sf;
	
	@Autowired
	public void setSessionFactory(SessionFactory sessionFactory) {
		this.sf = sessionFactory;
	}

	public Book getBook(int id) {
		Session sess = sf.openSession();
		Book b = sess.get(Book.class, id);
		sess.close();
		return b;
	}

	public Book getBook(String value, String column) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		CriteriaBuilder cb = sess.getCriteriaBuilder();
		CriteriaQuery<Book> cq = cb.createQuery(Book.class);
		Root<Book> rootEntry = cq.from(Book.class);
		CriteriaQuery<Book> all = cq.select(rootEntry).where(cb.equal(rootEntry.get(column), value));
		TypedQuery<Book> allQuery = sess.createQuery(all);
		List<Book>list=allQuery.getResultList();
		tx.commit();
		sess.close();
		return list.get(0);
	}
	
	// Overload method to be able to get book by price
	public Book getBook(double value, String column) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		CriteriaBuilder cb = sess.getCriteriaBuilder();
		CriteriaQuery<Book> cq = cb.createQuery(Book.class);
		Root<Book> rootEntry = cq.from(Book.class);
		CriteriaQuery<Book> all = cq.select(rootEntry).where(cb.equal(rootEntry.get(column), value));
		TypedQuery<Book> allQuery = sess.createQuery(all);
		List<Book> list = allQuery.getResultList();
		tx.commit();
		sess.close();
		return list.get(0);
	}

	public void saveBook(Book b) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		sess.save(b);
		tx.commit();
		sess.close();
	}

	public void updateBook(Book b) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		sess.saveOrUpdate(b);
		tx.commit();
		sess.close();
	}

	public void deleteBook(Book b) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		sess.delete(b);
		tx.commit();
		sess.close();
	}

}
