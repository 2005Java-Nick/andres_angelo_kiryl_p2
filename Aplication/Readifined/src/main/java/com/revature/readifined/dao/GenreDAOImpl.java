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

import com.revature.readifined.domain.BookTags;
import com.revature.readifined.domain.Genre;
@Component
public class GenreDAOImpl implements GenreDAO{

    private SessionFactory sf;
	
	@Autowired
	public void setSessionFactory(SessionFactory sessionFactory) {
		this.sf = sessionFactory;
	}
	
	@Override
	public Genre getGenre(int id) {
		Session sess = sf.openSession();
		Genre g = sess.get(Genre.class, id);
		sess.close();
		return g;
	}

	@Override
	public Genre getGenre(String value, String column) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		CriteriaBuilder cb = sess.getCriteriaBuilder();
		CriteriaQuery<Genre> cq = cb.createQuery(Genre.class);
		Root<Genre> rootEntry = cq.from(Genre.class);
		CriteriaQuery<Genre> all = cq.select(rootEntry).where(cb.equal(rootEntry.get(column), value));
		TypedQuery<Genre> allQuery = sess.createQuery(all);
		List<Genre>list=allQuery.getResultList();
		tx.commit();
		sess.close();
		return list.get(0);
	}

	@Override
	public void saveGenre(Genre g) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		sess.save(g);
		tx.commit();
		sess.close();
		
	}

	@Override
	public void updateGenre(Genre g) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		sess.update(g);
		tx.commit();
		sess.close();
		
	}

	@Override
	public void deleteGenre(Genre g) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		sess.delete(g);
		tx.commit();
		sess.close();
		
	}

}
