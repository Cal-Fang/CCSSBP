library(haven)
library(tidyverse)
setwd("~/Box Sync/CCSSBP Project")
# dataset = read_sav("0506.sav", encoding = "latin1")
# 
# write.csv(dataset, "0506.csv")

# STEP 1
# Read in the general population survey
gp <- read.csv("SRH Project/9.2020NCSS-SRH_200228cleaned_220208outCQF.csv")

# Export the variable names and relabel them in excel
# It's just easier
# varlist <- colnames(gp)
# write_excel_csv(as_data_frame(varlist), file = "data/varlist.csv")

# Read in the rename set and rename the columns
renames <- read.csv("data/varlist_rename.csv")
colnames(gp) <- renames$V_English

# STEP 2
# Create a new variable according to the city level 
level1 <- "北京、上海、广州、深圳"
level1_list <- as.list(strsplit(level1, split = "、")[[1]])
level1.5 <- "成都、重庆、杭州、武汉、西安、郑州、青岛、长沙、天津、苏州、南京、东莞、沈阳、合肥、佛山"
level1.5_list <- as.list(strsplit(level1.5, split = "、")[[1]])
level2 <- "昆明、福州、无锡、厦门、哈尔滨、长春、南昌、济南、宁波、大连、贵阳、温州、石家庄、泉州、南宁、金华、常州、珠海、惠州、嘉兴、南通、中山、保定、兰州、台州、徐州、太原、绍兴、烟台、廊坊"
level2_list <- as.list(strsplit(level2, split = "、")[[1]])
level3 <- "海口、汕头、潍坊、扬州、洛阳、乌鲁木齐、临沂、唐山、镇江、盐城、湖州、赣州、漳州、揭阳、江门、桂林、邯郸、泰州、济宁、呼和浩特、咸阳、芜湖、三亚、阜阳、淮安、遵义、银川、衡阳、上饶、柳州、淄博、莆田、绵阳、湛江、商丘、宜昌、沧州、连云港、南阳、蚌埠、驻马店、滁州、邢台、潮州、秦皇岛、肇庆、荆州、周口、马鞍山、清远、宿州、威海、九江、新乡、信阳、襄阳、岳阳、安庆、菏泽、宜春、黄冈、泰安、宿迁、株洲、宁德、鞍山、南充、六安、大庆、舟山"
level3_list <- as.list(strsplit(level3, split = "、")[[1]])
level4 <- "常德、渭南湖、孝感、丽水、运城、德州、张家口、鄂尔多斯、阳江、泸州、丹东、曲靖、乐山、许昌、湘潭、晋中、安阳、齐齐哈尔、北海、宝鸡、抚州、景德镇、延安、三明、抚顺、亳州、日照、西宁、衢州、拉萨、淮北、焦作、平顶山、滨州、吉安、濮阳、眉山、池州、荆门、铜仁、长治、衡水、铜陵、承德、达州、邵阳、德阳、龙岩、南平、淮南、黄石、营口、东营、吉林、韶关、枣庄、包头、怀化、宣城、临汾、聊城、梅州、盘锦、锦州、榆林、玉林、十堰、汕尾、咸宁、宜宾、永州、益阳、黔南州、黔东南、恩施、红河、大理、大同、鄂州、忻州、吕梁、黄山、开封、郴州、茂名、漯河、葫芦岛、河源、娄底、延边"
level4_list <- as.list(strsplit(level4, split = "、")[[1]])
level5 <- "汉中、辽阳、四平、内江、六盘水、安顺、新余、牡丹江、晋城、自贡、三门峡、赤峰、本溪、防城港、铁岭、随州、广安、广元、天水、遂宁、萍乡、西双版纳、绥化、鹤壁、湘西、松原、阜新、酒泉、张家界、黔西南、保山、昭通、河池、来宾、玉溪、梧州、鹰潭、钦州、云浮、佳木斯、克拉玛依、呼伦贝尔、贺州、通化、阳泉、朝阳、百色、毕节、贵港、丽江、安康、通辽、德宏、朔州、伊犁、文山、楚雄、嘉峪关、凉山、资阳、锡林郭勒盟、雅安、普洱、崇左、庆阳、巴音郭楞（巴州）、乌兰察布、白山、昌吉、白城、兴安盟、定西、喀什、白银、陇南、巴彦淖尔、巴中、鸡西、乌海、临沧、海东、张掖、商洛、黑河、哈密、吴忠、攀枝花、双鸭山、阿克苏、石嘴山、阿拉善盟、海西、平凉、林芝、固原、武威、儋州、吐鲁番、甘孜、辽源、临夏、铜川、金昌、鹤岗、伊春、中卫、怒江、和田、迪庆、甘南、阿坝、大兴安岭、七台河、山南、日喀则、塔城、博尔塔拉、昌都、阿勒泰、玉树、海南、黄南、果洛、克孜勒苏、阿里、海北、那曲、三沙"
level5_list <- as.list(strsplit(level5, split = "、")[[1]])

# Keep the first two characters for matching
level2_list <- unlist(lapply(level2_list, substr, start=1, stop=2))
level3_list <- unlist(lapply(level3_list, substr, start=1, stop=2))
level4_list <- unlist(lapply(level4_list, substr, start=1, stop=2))
level5_list <- unlist(lapply(level5_list, substr, start=1, stop=2))

# Change some mistake input
gp$sgeo2[gp$sgeo2 == "张家港市"] <- "苏州市"
gp$sgeo2[gp$sgeo2 == "昆山市"] <- "苏州市"
gp$sgeo2[gp$sgeo2 == "莱芜市"] <- "济南市"

# Filter out schools in Hang Kong, Macau, and Taiwan
# Create a new variable of the first two characters of sgeo2
# Match the new variables with the six lists above
gp <- gp %>% 
  filter(!(sgeo2 %in% c("香港", "澳门", "台湾"))) %>% 
  mutate(sgeo2_2 = substr(sgeo2, 1, 2),
         scityl = ifelse(sgeo2 == "张家界市", 6, 
                         ifelse(sgeo2_2 %in% level1_list, 1,
                                ifelse(sgeo2_2 %in% level1.5_list, 2,
                                       ifelse(sgeo2_2 %in% level2_list, 3, 
                                              ifelse(sgeo2_2 %in% level3_list, 4,
                                                     ifelse(sgeo2_2 %in% level4_list, 5,
                                                            ifelse(sgeo2_2 %in% level5_list, 6, 
                                                                   ifelse(sgeo2 %in% c("石河子市", "济源市", "仙桃市", "文昌市"), 5, NA)))))))))
# Transform the school tier variable
mylist <- list(bachelor1 = "一流大学",
               bachelor2 = "一流学科大学",
               bachelor3 = "普通本科高校",
               bachelor4 = "民办本科高校",
               associate1 = "重点专科院校",
               associate2 = "普通专科院校",
               associate3 = "民办专科院校")

gp <- enframe(mylist) %>%
  unnest(value) %>%
  right_join(gp, by = c('value' = 'slevel'))

# Take out the variables needed for describing
# Also filter out records of graduate students
gp_describe <- gp %>% 
  select(c(1, 3:32, 65:66, 210:233, scityl, weight)) %>% 
  filter(sttype == 1 | sttype == 2) %>% 
  filter(syear %in% c(2019, 2018, 2017, 2016)) %>% 
  rename(slevel = name)

# Test
nrow(gp[is.na(gp$scityl),]) == 0
gp$scityl[gp$sgeo2 == "张家界市"] == 6
gp$scityl[gp$sgeo2 == "张家口市"] == 5

# Save data
saveRDS(gp_describe, file="data/gp_describe.rds")
 
