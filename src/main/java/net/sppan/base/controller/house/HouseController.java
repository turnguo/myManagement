package net.sppan.base.controller.house;

import net.sppan.base.common.JsonResult;
import net.sppan.base.controller.BaseController;
import net.sppan.base.entity.House;
import net.sppan.base.entity.Resource;
import net.sppan.base.entity.Role;
import net.sppan.base.service.HouseService;
import net.sppan.base.service.specification.SimpleSpecificationBuilder;
import net.sppan.base.service.specification.SpecificationOperator;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.jpa.domain.Specifications;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.swing.filechooser.FileSystemView;
import java.io.File;

@Controller
@RequestMapping("/myHouse/house")
public class HouseController extends BaseController {
    @Autowired
    private HouseService houseService;
    @Value("${img.service.parh}")
    private String imgPathUrl;

    @RequestMapping("/index")
    public String index() {
        return "myHouse/house/index";
    }

    @RequestMapping(value = "/add", method = RequestMethod.GET)
    public String add(ModelMap map) {
        return "myHouse/house/add";
    }

    @RequestMapping(value = "/edit/{id}", method = RequestMethod.GET)
    public String edit(@PathVariable Integer id, ModelMap map) {
        House house = houseService.find(id);
        map.put("house", house);
        return "myHouse/house/edit";
    }

    @RequestMapping(value = "/check/{id}", method = RequestMethod.GET)
    public String check(@PathVariable Integer id, ModelMap map) {
        House house = houseService.find(id);
        map.put("path", house.getPath());
        return "myHouse/house/checkImg";
    }
    @RequestMapping("/list")
    @ResponseBody
    public Page<House> list( String community, String flag) {
        SimpleSpecificationBuilder<House> builder1 = new SimpleSpecificationBuilder<House>("isDeleted",SpecificationOperator.Operator.eq.name(),"n");
        SimpleSpecificationBuilder<House> builder = new SimpleSpecificationBuilder<House>();
       // builder.add("isDeleted",SpecificationOperator.Operator.eq.name(),"n");
        String searchText = request.getParameter("searchText");
        if(StringUtils.isNotBlank(searchText)){

            builder.addOr("community", SpecificationOperator.Operator.likeAll.name(), searchText);
            builder.addOr("telephone", SpecificationOperator.Operator.likeAll.name(), searchText);
        }

        Page<House> page = houseService.findAll(Specifications.where(builder1.generateSpecification()).and(builder.generateSpecification()),getPageRequest());
        return page;
    }

    @RequestMapping(value= {"/edit"},method = RequestMethod.POST)
    @ResponseBody
    public JsonResult edit(@RequestParam("files") MultipartFile[] files, House house)  {
        try {
            Integer maxId;
            if(house.getId()==null){
                maxId = houseService.findMaxId()+1;
            }else {
                maxId= house.getId();
            }
            //判断文件目录是否存在
            String path = FileSystemView.getFileSystemView().getHomeDirectory()+File.separator  +"img"+File.separator +maxId;
            File parentDest = new File(path);
            if( !parentDest.exists()){
                parentDest.mkdir();   //不存在就创建
            }

            String paths="";
            String fileNames="";
            if(!StringUtils.isBlank(house.getPath())){
                paths=house.getPath();
                fileNames =house.getFileName();
            }
            System.out.println(files.length);
            if(files.length!=0){
                for(int i=0;i<files.length;i++){
                    //文件路径
                    String realPath =path+File.separator  + files[i].getOriginalFilename();
                    fileNames+=  files[i].getOriginalFilename()+",";
                    paths+= imgPathUrl+maxId+"/" +files[i].getOriginalFilename()+",";
                    File dest = new File(realPath);
                    //保存文件
                    files[i].transferTo(dest);
                }
            }
            if(StringUtils.isBlank(paths)){
                paths=null;
            }
            house.setPath(paths);
            house.setFileName(fileNames);
            house.setIsDeleted("n");
            houseService.saveOrUpdate(house);
        } catch (Exception e) {
            return JsonResult.failure(e.getMessage());
        }
        return JsonResult.success();
    }
    @RequestMapping(value = "/delete/{id}", method = RequestMethod.POST)
    @ResponseBody
    public JsonResult delete(@PathVariable Integer id,ModelMap map) {
        try {
            House house = houseService.find(id);
            house.setIsDeleted("y");
            houseService.saveOrUpdate(house);
        } catch (Exception e) {
            e.printStackTrace();
            return JsonResult.failure(e.getMessage());
        }
        return JsonResult.success();
    }
}
