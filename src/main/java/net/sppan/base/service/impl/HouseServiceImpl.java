package net.sppan.base.service.impl;

import net.sppan.base.common.utils.MD5Utils;
import net.sppan.base.dao.HouseDao;
import net.sppan.base.dao.support.IBaseDao;
import net.sppan.base.entity.House;
import net.sppan.base.entity.User;
import net.sppan.base.service.HouseService;
import net.sppan.base.service.support.impl.BaseServiceImpl;
import org.apache.shiro.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;


@Service
public class HouseServiceImpl extends BaseServiceImpl<House, Integer> implements HouseService {
    @Autowired
    private HouseDao houseDao;
    @Override
    public IBaseDao<House, Integer> getBaseDao() {
        return houseDao;
    }

    @Override
    public House saveOrUpdate(House house) {
        User user =   (User)SecurityUtils.getSubject().getPrincipal();
        House h ;
        if(house.getId() != null){
            house.setModifier(user.getUserName());
            house.setChangeTime(new Date());
          h= update(house);
        }else{
            house.setCreator(user.getUserName());
            house.setModifier(user.getUserName());
            house.setCreationTime(new Date());
            house.setChangeTime(new Date());
            h=  save(house);
        }
        return h;
    }

    @Override
    public Integer findMaxId() {
        return houseDao.findMaxId();
    }
}
