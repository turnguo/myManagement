package net.sppan.base.dao;


import net.sppan.base.dao.support.IBaseDao;
import net.sppan.base.entity.House;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;



@Repository
public interface HouseDao  extends IBaseDao<House, Integer> {

   // @Modifying
    @Query(nativeQuery = true,value = "select MAX(id) from house")
    Integer findMaxId();
}
