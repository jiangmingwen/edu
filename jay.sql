/*
README
1.版本顺序需要从小到大排列
2.默认产品名称为当前
*/

DELIMITER $$$$$$
/*
* 创建数据库配置表
* db_conf表结构：
* id --- version --- feature --- product --- remark---update_time
* 主键   版本         功能        产品       备注      更新时间
*/
 CREATE TABLE IF NOT EXISTS db_conf  (
		`id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
		`version` float(8) NULL COMMENT '版本',
		`feature` varchar(16) NULL COMMENT '功能',
		`product` varchar(32) NULL COMMENT '产品',
		`remark` varchar(255) NULL COMMENT '备注',
		`update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
		PRIMARY KEY (`id`)
 );

/*
*创建函数
*判断数据表名是否存在的函数
*/
DROP FUNCTION IF EXISTS TABLE_EXISTS;
CREATE  FUNCTION  TABLE_EXISTS(table_name text) RETURNS boolean 
BEGIN
    IF EXISTS(
        SELECT 1 FROM information_schema.TABLES 
            WHERE TABLE_SCHEMA = (SELECT DATABASE()) AND TABLE_NAME = table_name
        ) THEN RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;

/*
* 获取数据库版本的函数
*
*/
DROP FUNCTION IF EXISTS GET_DB_VERSION;
CREATE  FUNCTION  GET_DB_VERSION () RETURNS float  
BEGIN
    DECLARE current_version float DEFAULT 0;
    IF (SELECT TABLE_EXISTS('db_conf') IS FALSE) THEN
        RETURN current_version;
    ELSEIF EXISTS(SELECT 1 FROM db_conf) THEN
				SELECT version INTO current_version FROM db_conf WHERE feature = 'db_version';
				RETURN current_version;
		ELSE
			  RETURN current_version;       
    END IF;
END;


/*
* 更新数据库版本
*/
DROP   PROCEDURE   IF  EXISTS  UPDATE_DB_VERSION;
CREATE  PROCEDURE UPDATE_DB_VERSION(version float) 
BEGIN
    IF EXISTS(SELECT 1 FROM db_conf WHERE feature='db_version') THEN
        UPDATE db_conf SET version=version,update_time=now()  WHERE feature='db_version';
    ELSE
        INSERT INTO db_conf (version,feature,remark) VALUES(version,'db_version','脚本升级');
    END IF;
END;

-- ------------------------------数据库每个版本按从小到大排列------------------------------------------------
/*
* 版本初始模板
↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
-- 1.0开始
DROP  PROCEDURE  IF  EXISTS  DB_UPGRADE;
CREATE  PROCEDURE DB_UPGRADE(version float) 
BEGIN
    IF( GET_DB_VERSION() < version) THEN
        START TRANSACTION;
-- ------------SQL语句起始线---------------
        

-- ------------SQL语句结束线-------------------
            CALL UPDATE_DB_VERSION(version);
        COMMIT;
    END IF;
END;
CALL DB_UPGRADE(1);
-- 1.0结束
↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
*
*/

-- 1.0开始
DROP  PROCEDURE  IF  EXISTS  DB_UPGRADE;
CREATE  PROCEDURE DB_UPGRADE(version float) 
BEGIN
    IF( GET_DB_VERSION() < version) THEN
        START TRANSACTION;
-- ------------SQL语句起始线---------------
            -- 课程
            CREATE TABLE sys_course  (
                `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
                `name` varchar(16) NULL COMMENT '课程名称',
                `simple_name` varchar(16) NULL COMMENT '课程简称',
                `type` int(1) NULL COMMENT '课程类型：枚举：COURSE_TYPE: { 1 = 文化，2=艺术，3=体考 }',
                `code` varchar(16) NULL COMMENT '课程代码',
                `level` int(1) NULL COMMENT '课程等级：枚举：COURSE_LEVEL:{1=国家课程，2=地方课程，3=校本课程}',
                `teach_type` int(1) NULL COMMENT '授课方式：枚举：TEACH_TYPE:{1=面授讲课，2=辅导，3=录像讲课，4=网络教学，5=实验，6=实习，7=其他}',
                `serial` varchar(16) NULL COMMENT '课程编号',
                `textbook_code` varchar(16) NULL COMMENT '教材编码',
                `bibliography` varchar(32) NULL COMMENT '参考书目',
                `total_time` int(8) NULL COMMENT '总学时：单位h',
                `week_time` int(8) NULL COMMENT '周学时',
                `self_study_time` int(8) NULL COMMENT '自学学时',
                `sort_no` int(2) NULL COMMENT '排序序号',
                `introduction` text NULL COMMENT '课程简介',
                `claim` text NULL COMMENT '课程要求',
                `is_exam` tinyint(1) NULL COMMENT '是否考试科目：枚举：IS_EXAM_COURSE:{1=是，0=否}',
                `update_time` datetime NULL COMMENT '修改时间',
                `remark` text NULL COMMENT '备注',
                `org_id` int NULL COMMENT '组织架构表（sys_org）id',
                `delete_flag` tinyint(1) NULL COMMENT '删除标识，枚举',
                PRIMARY KEY (`id`)
            );

            -- 模块
            CREATE TABLE sys_module  (
                `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
                `product` varchar(32) NULL COMMENT '产品',
                `client_type` int(1) NULL COMMENT '设备终端，枚举：CLIENT_TYPE:{1=移动端，2=PC端}',
                `product_type` int(1) NULL COMMENT '业务终端，枚举：PRODUCT_TYPE:{1=B端，2=C端}',
                `module_name` varchar(255) NULL COMMENT '模块名称',
                `delete_flag` tinyint(1) NULL COMMENT '删除标识，枚举',
                `update_time` datetime NULL COMMENT '修改时间',
                `remark` text NULL COMMENT '备注',
                PRIMARY KEY (`id`)
            );

            -- 页面
            CREATE TABLE sys_page (
                `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
                `module_id` int(16) NULL COMMENT '模块表id',
                `name` varchar(16) NULL COMMENT '页面名称',
                `code` int(1) NULL COMMENT '页面编码',
                `delete_flag` tinyint(1) NULL COMMENT '删除标识，枚举',
                `update_time` datetime NULL COMMENT '修改时间',
                `remark` text NULL COMMENT '备注',
                PRIMARY KEY (`id`)
            );

            -- 权限
            CREATE TABLE sys_permission  (
                `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
                `page_id` int(16) NULL COMMENT '页面表id',
                `name` varchar(16) NULL COMMENT '权限名称',
                `code` int(1) NULL COMMENT '权限编码',
                `delete_flag` tinyint(1) NULL COMMENT '删除标识，枚举',
                `update_time` datetime NULL COMMENT '修改时间',
                `remark` text NULL COMMENT '备注',
                PRIMARY KEY (`id`)
            );

            -- 角色
            CREATE TABLE sys_role  (
                `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
                `name` varchar(16) NULL COMMENT '角色名称',
                `code` int(1) NULL COMMENT '角色编码',
                `delete_flag` tinyint(1) NULL COMMENT '删除标识，枚举',
                `update_time` datetime NULL COMMENT '修改时间',
                `remark` text NULL COMMENT '备注',
                `tags` varchar(255) NULL COMMENT '标签，数组以“，”分割',
                PRIMARY KEY (`id`)
            );

            -- 用户
            CREATE TABLE sys_user  (
                `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
                `name` varchar(16) NULL COMMENT '用户名称',
                `username` varchar(16) NULL COMMENT '用户名',
                `delete_flag` tinyint(1) NULL COMMENT '删除标识，枚举',
                `update_time` datetime NULL COMMENT '修改时间',
                `remark` text NULL COMMENT '备注',
                `tags` varchar(255) NULL COMMENT '标签，数组以“，”分割',
                `password` varchar(255) NULL COMMENT '密码',
                `phone` varchar(11) NULL COMMENT '电话',
                `email` varchar(32) NULL COMMENT '邮箱',
                `staff` varchar(32) NULL COMMENT '工号',
                `fullname` varchar(8) NULL COMMENT '全名',
                `wx_id` varchar(32) NULL COMMENT '微信id',
                `ding_id` varchar(32) NULL COMMENT '钉钉id',
                `wx_qy_id` varchar(32) NULL COMMENT '企业微信id',
                PRIMARY KEY (`id`)
            );

            -- 用户对应角色
            CREATE TABLE sys_user_map_role  (
                `user_id` int(32) NOT NULL COMMENT '用户表id',
                `role_id` int(32) NULL COMMENT '角色表id'
            );

            -- 角色对应权限
            CREATE TABLE sys_role_map_permission  (
                `role_id` int(32) NOT NULL COMMENT '角色表id',
                `permission_id` int(32) NULL COMMENT '权限表id'
            );

            -- 组织
            CREATE TABLE sys_org  (
                `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
                `name` varchar(16) NULL COMMENT '单位名称',
                `category` int(1) NULL COMMENT '单位分类：枚举ORGANIZATION_CATEGORY：{\r\n1=市级主管单位，\r\n2=区级主管单位，\r\n3=直属单位（特殊机构）,\r\n4=教管中心，\r\n5=学校（含分校），\r\n6=校区\r\n}',
                `delete_flag` tinyint(1) NULL COMMENT '删除标识，枚举',
                `update_time` datetime NULL COMMENT '修改时间',
                `remark` text NULL COMMENT '备注',
                `type` int(2) NULL COMMENT '单位类别：枚举ORGANIZATION_TYPE：{\r\n1=教学院系,\r\n2=科研机构,\r\n3=公共服务,\r\n4=党务部门,\r\n5=行政机构,\r\n6=附属单位,\r\n7=后勤部门,\r\n8=校办产业,\r\n9=行政机构,\r\n10=其他\r\n} 如果是学校：',
                `do_type` int(2) NULL COMMENT '单位办别：枚举ORGANIZATION_DOTYPE:{\r\n1=公办,\r\n2=民办，\r\n3=中外合作办，\r\n4=民办公助,\r\n5=教育部门和集体办，\r\n6=社会力量办，\r\n7=其他部门办，\r\n8=直属（校办），\r\n9=校企合办，\r\n10=其他\r\n}',
                `parent_id` int NULL COMMENT '上级id',
                `code` varchar(32) NULL COMMENT '单位编码',
                `simple_name` varchar(16) NULL COMMENT '单位简称',
                `simple_pinyin` varchar(64) NULL COMMENT '单位简拼',
                `en_name` varchar(64) NULL COMMENT '英文名称',
                `en_simple` varchar(32) NULL COMMENT '英文简称',
                `setup_time` datetime NULL COMMENT '成立时间',
                `address` varchar(255) NULL COMMENT '单位地址',
                `detail_address` varchar(255) NULL COMMENT '详细地址',
                `school_type` int(1) NULL COMMENT '学校类型：SCHOOL_TYPE:{1=幼儿园，2=村小,3=小学，4=初级中学，5=九年制学校，6=高级中学，7=完全中学，8=职业院校}',
                `district` varchar(64) NULL COMMENT '行政区划分',
                `city_type` int(1) NULL COMMENT '所属城乡类型：枚举 CITY_TYPE:{1=城区，2=镇区，3=乡村}',
                PRIMARY KEY (`id`)
            );

            -- 老师
            CREATE TABLE sys_teacher  (
                `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
                `delete_flag` tinyint(1) NULL COMMENT '删除标识，枚举',
                `update_time` datetime NULL COMMENT '修改时间',
                `org_id` int NULL COMMENT '学校，sys_org表的id',
                `user_id` int NULL COMMENT 'sys_user表的id',
                `fullname` varchar(16) NULL COMMENT '姓名',
                `former_name` varchar(16) NULL COMMENT '曾用名',
                `head_img` varchar(32) NULL COMMENT '个人头像',
                `card_type` int(1) NULL COMMENT '证件类型，枚举',
                `idcard` varchar(32) NULL COMMENT '证件号',
                `country` varchar(32) NULL COMMENT '国籍',
                `sex` varchar(32) NULL COMMENT '性别',
                `csry` varchar(16) NULL COMMENT '出生年月',
                `jg` varchar(16) NULL COMMENT '籍贯',
                `mz` int(2) NULL COMMENT '民族：枚举MZ',
                `csd` varchar(32) NULL COMMENT '出生地',
                `xl` int(2) NULL COMMENT '最高学历，枚举，XL',
                `zzmm` int(2) NULL COMMENT '政治面貌，枚举，ZZMM',
                `jkzk` int(1) NULL COMMENT '健康状况,枚举，ZKZK',
                `hyzk` int(1) NULL COMMENT '婚姻状况，枚举，HYZK,{1=已婚，0=未婚}',
                `contract` int(1) NULL COMMENT '签订合同情况,枚举CONTRACT:{1=未签合同，2=聘用合同，3=劳动合同，4=其他合同}',
                `origin` int(1) NULL COMMENT '职工来源，枚举，MEMBER_ORIGIN:{1=分配，2=公招，3=调入，4=聘用，5=其他}',
                `come_time` datetime NULL COMMENT '进本校时间',
                `work_start_time` datetime NULL COMMENT '参加工作年月',
                `work_type` int(2) NULL COMMENT '职工类别,枚举',
                `import_type` int(2) NULL COMMENT '用人形式,枚举',
                `job_level` int(2) NULL COMMENT '职称，枚举', 
                `course_id` int NULL COMMENT 'sys_course表的id',
                `period` int(2) NULL COMMENT '任教学段,枚举',
                `dnzw` int(2) NULL COMMENT '党内职务,枚举',
                `xzzw` int(2) NULL COMMENT '行政职务,枚举',
                `xrgwdj` int(2) NULL COMMENT '现任岗位等级,枚举',
                `gwjb` int(2) NULL COMMENT '岗位级别,枚举',
                `is_qrzsfl` int(1) NULL COMMENT '是否全日制师范类专业,枚举，boolean',
                `is_sgtjzypypx` int(1) NULL COMMENT '是否受过特教专业培养培训,枚举，boolean',
                `is_tsjycyzs` int(1) NULL COMMENT '是否有特殊教育从业证书,枚举，boolean',
                `is_cjjcfwxm` int(1) NULL COMMENT '是否参加基层服务项目,枚举，boolean',
                `is_mfsfs` int(1) NULL COMMENT '是否属于免费（公费）师范生,枚举，boolean',
                `is_tjjzg` int(1) NULL COMMENT '是否是特级教职工,枚举，boolean',
                `is_xjjysggjzg` int(1) NULL COMMENT '是否县级及以上骨干教职工,枚举，boolean',
                `is_xljkjzg` int(1) NULL COMMENT '是否心里健康教育教职工,枚举，boolean',
                `is_ssxjzg` int(1) NULL COMMENT '是否双师型教职工,枚举，boolean',
                `is_qrzxqjyzyby` int(1) NULL COMMENT '是否全日制学前教育专业毕业,枚举，boolean',
                `is_zyjndjzs` int(1) NULL COMMENT '是否具备职业技能等级证书,枚举，boolean',
                `is_xqjyzypypx` int(1) NULL COMMENT '是否受过学前教育专业培养培训,枚举，boolean',
                `is_qrztsjyzyby` int(1) NULL COMMENT '是否全日制特殊教育专业毕业,枚举，boolean',
                `work_long_time` int(8) NULL COMMENT '企业工作（实践）时长',
                `it_level` int(8) NULL COMMENT '信息技术应用能力,枚举',
                `jcxm_start_time` datetime NULL COMMENT '参加基层服务项目起始年月',
                `jcxm_end_time` datetime NULL COMMENT '参加基层服务项目结束年月',
                `cstj_start_time` datetime NULL COMMENT '从事特教起始年月',
                `staff` varchar(32) NULL COMMENT '工号',
                PRIMARY KEY (`id`)
            );

            -- 学生
            CREATE TABLE sys_student  (
                `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
                `delete_flag` tinyint(1) NULL COMMENT '删除标识，枚举',
                `update_time` datetime NULL COMMENT '修改时间',
                `org_id` int NULL COMMENT '学校，sys_org表的id',
                `user_id` int NULL COMMENT 'sys_user表的id',
                `fullname` varchar(16) NULL COMMENT '姓名',
                `en_name` varchar(16)  NULL COMMENT '英文名',
                `former_name` varchar(16) NULL COMMENT '曾用名',
                `head_img` varchar(32) NULL COMMENT '个人头像',
                `card_type` int(1) NULL COMMENT '证件类型，枚举',
                `idcard` varchar(32) NULL COMMENT '证件号',
                `country` varchar(32) NULL COMMENT '国籍',
                `sex` varchar(32) NULL COMMENT '性别',
                `csry` varchar(16) NULL COMMENT '出生年月',
                `jg` varchar(16) NULL COMMENT '籍贯',
                `mz` int(2) NULL COMMENT '民族：枚举MZ',
                `csd` varchar(32) NULL COMMENT '出生地',
                `zzmm` int(2) NULL COMMENT '政治面貌，枚举，ZZMM',
                `jkzk` int(1) NULL COMMENT '健康状况,枚举，ZKZK',
                `come_time` datetime NULL COMMENT '入学年月',
                `period` int(2) NULL COMMENT '学业阶段，枚举,',
                `student_type` int(1) NULL COMMENT '学生类型，枚举',
                `study_type` int(1) NULL COMMENT '就读方式,枚举',
                `grade_id` int NULL COMMENT '年级表(sys_grade)的id',
                `class_id` int NULL COMMENT '班级表(sys_class)的id',
                `is_ldrk` int(1) NULL COMMENT '是否流动人口,枚举，boolean',
                `address` varchar(255) NULL COMMENT '通讯地址',
                `home_address` varchar(255) NULL COMMENT '户口地址',
                `blood_type` int(1) NULL COMMENT '血型，枚举',
                `now_address` varchar(255) NULL COMMENT '现住址',
                `status` int(1) NULL COMMENT '状态，枚举',
                `post_code` varchar(12) NULL COMMENT '邮政编码',
                `study_code` varchar(16) NULL COMMENT '学号',
                PRIMARY KEY (`id`)
            ); 

            -- 家庭成员
            CREATE TABLE sys_family  (
                `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
                `delete_flag` tinyint(1) NULL COMMENT '删除标识，枚举',
                `update_time` datetime NULL COMMENT '修改时间',
                `user_id` int NULL COMMENT 'sys_user表的id',
                `name` varchar(16) NULL COMMENT '姓名',
                `relation` int(1) NULL COMMENT '关系，枚举',
                `card_type` int(1) NULL COMMENT '证件类型，枚举',
                `idcard` varchar(32) NULL COMMENT '证件号',
                `sex` varchar(32) NULL COMMENT '性别',
                `csry` varchar(16) NULL COMMENT '出生年月',
                `now_address` varchar(255) NULL COMMENT '现住址',
                `phone` varchar(11) NULL COMMENT '电话号码',
                `email` varchar(32) NULL COMMENT '邮箱',
                `mz` int(2) NULL COMMENT '民族：枚举MZ',
                `is_jhr` int(1) NULL COMMENT '是否是监护人,枚举，boolean',
                `hk_ssq` varchar(32) NULL COMMENT '户口省市区',
                `company` varchar(64) NULL COMMENT '工作单位',
                PRIMARY KEY (`id`)
            );

            -- 年级
            CREATE TABLE sys_grade  (
                `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
                `delete_flag` tinyint(1) NULL COMMENT '删除标识，枚举',
                `update_time` datetime NULL COMMENT '修改时间',
                `org_id` int NULL COMMENT '学校，sys_org表的id',
                `period` int(2) NULL COMMENT '学业阶段，枚举,',         
                `name` varchar(16) NULL COMMENT '年级名称',
                `class_prefix` varchar(16) NULL COMMENT '班级前缀',
                `class_start` int(3) NULL COMMENT '班级起始编号',
                `class_end` int(3) NULL COMMENT '班级结束编号',
                `grade` int(1) NULL COMMENT '所属年级，枚举，根据period字段不同，所属年级不同',
                `come_time` datetime NULL COMMENT '入学年月',
                `sort_no` int(3) NULL COMMENT '排序编号',
                `is_completed` int(1) NULL COMMENT '是否已经毕业,枚举，boolean',
                `maintainer_id` int NULL COMMENT 'sys_teacher表的id',
                PRIMARY KEY (`id`)
            );
            
            -- 班级
            CREATE TABLE sys_class  (
                `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
                `delete_flag` tinyint(1) NULL COMMENT '删除标识，枚举',
                `update_time` datetime NULL COMMENT '修改时间',
                `grade_id` int NULL COMMENT 'sys_grade表的id',
                `name` varchar(16) NULL COMMENT '班级名称',
                `head_master_id` int NULL  COMMENT 'sys_teacher表的id',
                `sort_no` int(3) NULL COMMENT '排序编号',
                PRIMARY KEY (`id`) 
            );

            -- 班级科目老师
            CREATE TABLE sys_subject_teacher  (
                `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
                `delete_flag` tinyint(1) NULL COMMENT '删除标识，枚举',
                `update_time` datetime NULL COMMENT '修改时间',
                `class_id` int NULL COMMENT 'sys_grade表的id',
                `course_id` int NULL COMMENT 'sys_course表的id',
                `teacher_id` int NULL COMMENT 'sys_teacher表的id',
                PRIMARY KEY (`id`) 
            );

            -- 学习简历
            CREATE TABLE sys_study_notes  (
                `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
                `student_id` int NULL COMMENT 'sys_student表的id',
                `study_start_time` datetime NULL COMMENT '学习起始时间',
                `study_end_time` datetime NULL COMMENT '学习结束时间',
                `study_company` varchar(32) NULL COMMENT '学习单位',
                `subject` varchar(16) NULL COMMENT '专业名称',
                `degree` int(1) NULL COMMENT '学位：枚举',
                `witness` varchar(8) NULL COMMENT '证明人',
                `study_content` text NULL COMMENT '学习内容',
                `remark` text NULL COMMENT '备注',
                `update_time` datetime NULL COMMENT '更新时间',
                `delete_flag` tinyint(1) NULL COMMENT '删除标识，枚举',
                PRIMARY KEY (`id`)
            );

            -- 学生来源
            CREATE TABLE sys_student_source  (
                `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
                `student_id` int NULL COMMENT 'sys_student表的id',
                `remark` text NULL COMMENT '备注',
                `update_time` datetime NULL COMMENT '更新时间',
                `delete_flag` tinyint(1) NULL COMMENT '删除标识，枚举',
                `from_school` varchar(16) NULL COMMENT '原学校名称',
                `study_code_old` varchar(16) NULL COMMENT '原学号',
                `admission_type` int(1) NULL COMMENT '入学方式：枚举',
                `from_city` varchar(32) NULL COMMENT '来源地区',
                PRIMARY KEY (`id`)
            );
            
            -- 政治面貌
            CREATE TABLE sys_zzmm  (
                `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
                `student_id` int NULL COMMENT 'sys_student表的id',
                `remark` text NULL COMMENT '备注',
                `update_time` datetime NULL COMMENT '更新时间',
                `delete_flag` tinyint(1) NULL COMMENT '删除标识，枚举',
                `zzmm` int(1) NULL COMMENT '政治面貌，枚举',
                `company` varchar(16) NULL COMMENT '参加所在单位',
                `join_date` datetime NULL COMMENT '参加日期',
                `exception` int(1) NULL COMMENT '异常类别，枚举',
                `introducer` varchar(8) NULL COMMENT '介绍人',
                `exception_date` datetime NULL COMMENT '异常日期',
                `formal_date` datetime NULL COMMENT '转正日期',
                `from_company` varchar(16) NULL COMMENT '转入前单位',
                `exception_reason` text NULL COMMENT '异常原因',
                `leave_date` datetime NULL COMMENT '转出日期',
                `enter_date` datetime NULL COMMENT '转入日期',
                PRIMARY KEY (`id`)
            );

            -- 住宿信息
            CREATE TABLE  sys_dormitory (
                `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
                `student_id` int NULL COMMENT 'sys_student表的id',
                `remark` text NULL COMMENT '备注',
                `update_time` datetime NULL COMMENT '更新时间',
                `delete_flag` tinyint(1) NULL COMMENT '删除标识，枚举',
                `enter_date` datetime NULL COMMENT '入住日期',
                `leave_date` datetime NULL COMMENT '迁出日期',
                `address` varchar(64) NULL COMMENT '校外住址',
                `building_no` varchar(8) NULL COMMENT '建筑物号',
                `room_no` varchar(8) NULL COMMENT '宿舍号',
                `bed_no` varchar(8) NULL COMMENT '床位号',
                PRIMARY KEY (`id`)
            );

            -- 家庭经济状况
            CREATE TABLE sys_income  (
                `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
                `student_id` int NULL COMMENT 'sys_student表的id',
                `remark` text NULL COMMENT '备注',
                `update_time` datetime NULL COMMENT '更新时间',
                `delete_flag` tinyint(1) NULL COMMENT '删除标识，枚举',
                `member_num` int(2) NULL COMMENT '家庭人口',
                `famliy_type` int(1) NULL COMMENT '家庭类别',
                `support_num` int(2) NULL COMMENT '赡养人口',
                `difficult_reason` text NULL COMMENT '困难原因',
                `manpower_num` int(2) NULL COMMENT '劳动力人口',
                `difficult_level` int(1) NULL COMMENT '困难程度，枚举',
                `per_capita_income` int(12) NULL COMMENT '家庭人均收入，年/元',
                `is_db` int(1) NULL COMMENT '是否低保,枚举，boolean',
                `income_source` varchar(16) NULL COMMENT '收入来源',
                `account_types` int(1) NULL COMMENT '入学前户口类别，枚举',
                `db_line` varchar(8) NULL COMMENT '就学地低保线',
                PRIMARY KEY (`id`)
            );

            -- 入学考试
            CREATE TABLE sys_entrance_examination  (
                `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
                `student_id` int NULL COMMENT 'sys_student表的id',
                `remark` text NULL COMMENT '备注',
                `update_time` datetime NULL COMMENT '更新时间',
                `delete_flag` tinyint(1) NULL COMMENT '删除标识，枚举',
                `course_id` int NULL COMMENT '课程表sys_course表的id',
                `score_num` int NULL COMMENT '考试分数成绩',
                `score_level` int(1) NULL COMMENT '考试等级成绩，枚举',
                PRIMARY KEY (`id`)
            );

            -- 奖励信息
            CREATE TABLE sys_award  (
            `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
            `student_id` int NULL COMMENT 'sys_student表的id',
            `remark` text NULL COMMENT '备注',
            `update_time` datetime NULL COMMENT '更新时间',
            `delete_flag` tinyint(1) NULL COMMENT '删除标识，枚举',
            `name` varchar(16) NULL COMMENT '奖励名称',
            `date` datetime NULL COMMENT '奖励时间',
            `award_host` varchar(16) NULL COMMENT '颁奖单位',
            `type` int(1) NULL COMMENT '奖励级别，枚举',
            `money` int(8) NULL COMMENT '奖励金额',
            `level` int(1) NULL COMMENT '奖励等级，枚举',
            `no` varchar(16) NULL COMMENT '颁奖文号',
            `category` int(1) NULL COMMENT '奖励类型，枚举',
            `reason` text NULL COMMENT '获奖原因',
            `method` int(1) NULL COMMENT '奖励方式',
            PRIMARY KEY (`id`)
            );

            -- 处分信息
            CREATE TABLE sys_punish  (
                `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
                `student_id` int NULL COMMENT 'sys_student表的id',
                `remark` text NULL COMMENT '备注',
                `update_time` datetime NULL COMMENT '更新时间',
                `delete_flag` tinyint(1) NULL COMMENT '删除标识，枚举',
                `date` datetime NULL COMMENT '处分日期',
                `revoke_date` datetime NULL COMMENT '撤销处分日期',
                `no` varchar(16) NULL COMMENT '处分文号',
                `revoke_no` varchar(16) NULL COMMENT '撤销文号',
                `reason` text NULL COMMENT '处分原因',
                `revoke_reason` text NULL COMMENT '撤销原因',
                `name` varchar(32) NULL COMMENT '处分名称',
                PRIMARY KEY (`id`)
            );

            -- 结束学业
            CREATE TABLE sys_end_school  (
                `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
                `student_id` int NULL COMMENT 'sys_student表的id',
                `remark` text NULL COMMENT '备注',
                `update_time` datetime NULL COMMENT '更新时间',
                `delete_flag` tinyint(1) NULL COMMENT '删除标识，枚举',
                `code` varchar(16) NULL COMMENT '结束学业码',
                `date` datetime NULL COMMENT '结束学业年月',
                `reason` varchar(255) NULL COMMENT '结束学业原因',
                PRIMARY KEY (`id`)
            );

            -- 毕业信息
            CREATE TABLE sys_graduation  (
                `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
                `student_id` int NULL COMMENT 'sys_student表的id',
                `remark` text NULL COMMENT '备注',
                `update_time` datetime NULL COMMENT '更新时间',
                `delete_flag` tinyint(1) NULL COMMENT '删除标识，枚举',
                `to` varchar(16) NULL COMMENT '毕业去向',
                `certificate_code` varchar(32) NULL COMMENT '毕业证书号',
                `get_date` datetime NULL COMMENT '证书获取时间',
                `is_recive` int(1) NULL COMMENT '是否已经领取,枚举',
                `graduation_date` datetime NULL COMMENT '毕业时间',
                `comments` text NULL COMMENT '毕业评语',
                `end_school_code` varchar(16) NULL COMMENT '结束学业码',
                PRIMARY KEY (`id`)
            );

            -- 系统菜单
            CREATE TABLE sys_menus  (
                `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
                `org_id` int NULL COMMENT 'sys_org表的id',
                `remark` text NULL COMMENT '备注',
                `update_time` datetime NULL COMMENT '更新时间',
                `delete_flag` tinyint(1) NULL COMMENT '删除标识，枚举',
                `name` varchar(16) NULL COMMENT '菜单名称',
                `parent_id` int NULL COMMENT '上级节点的id',
                `icon` varchar(16) NULL COMMENT '图标',
                `link_type` int(1) NULL COMMENT '链接类型，枚举{path,iframe,href_inner,href_blank}',
                `url` varchar(255) NULL COMMENT '链接地址',
                PRIMARY KEY (`id`)
            );

            -- 招生学段
            CREATE TABLE rs_period  (
                `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
                `name` varchar(16) NULL COMMENT '学段名称',
                `enabled` tinyint(1) NULL COMMENT '是否开启，枚举，boolean',
                `age_min` int(2) NULL COMMENT '最小年龄',
                `age_max` int(2) NULL COMMENT '最大年龄',
                `code` varchar(8) NULL COMMENT '学段，枚举',
                `delete_flag` tinyint(1) NULL COMMENT '删除标识',
                `remark` varchar(255) NULL COMMENT '备注',
                `update_time` datetime NULL COMMENT '更新时间',
                PRIMARY KEY (`id`)
            );

            -- 招生学段批次分类
            CREATE TABLE rs_period_batch  (
                `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
                `name` varchar(16) NULL COMMENT '批次名称',
                `delete_flag` tinyint(1) NULL COMMENT '删除标识',
                `remark` varchar(255) NULL COMMENT '备注',
                `update_time` datetime NULL COMMENT '更新时间',
                `read_notes` text NULL COMMENT '阅读须知',
                `tips` varchar(255) NULL COMMENT '提示消息',
                `read_seconds` int(3) NULL COMMENT '阅读须知的时间',
                `period_id` int NULL COMMENT 'rs_period表的id',
                `parent_id` int NULL COMMENT '上级id，没有就是一类批次',
                PRIMARY KEY (`id`)
            );

            -- 地址匹配规则
            CREATE TABLE rs_address_rule  (
                `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
                `remark` varchar(255) NULL COMMENT '备注',
                `update_time` datetime NULL COMMENT '更新时间',
                `period_batch_id` int NULL COMMENT 'rs_period_batch表的id',
                `address_field` int(1) NULL COMMENT '地址匹配字段,枚举',
                `address_target_field` int(1) NULL COMMENT '地址匹配目标，枚举',
                PRIMARY KEY (`id`)
            );

            -- 文章
            CREATE TABLE rs_article  (
                `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
                `remark` varchar(255) NULL COMMENT '备注',
                `update_time` datetime NULL COMMENT '更新时间',
                `delete_flag` tinyint(1) NULL COMMENT '删除标识，枚举',
                `type` int(1) NULL COMMENT '文章类型，枚举',
                `status` int(1) NULL COMMENT '状态，枚举：草稿，发布',
                `release_time` datetime NULL COMMENT '发布日期',
                `title` varchar(32) NULL COMMENT '文章标题',
                `view_count` int(8) NULL COMMENT '浏览量',
                `user_id` int NULL COMMENT 'sys_user表的id',
                `user_fullname` varchar(16) NULL COMMENT '发布用户',
                `org` varchar(32) NULL COMMENT '发布机构',
                `no` varchar(32) NULL COMMENT '文案号',
                `tags` varchar(255) NULL COMMENT '标签，逗号分隔',
                `content` longtext NULL COMMENT '富文本，内容',
                `files` text NULL COMMENT '附件：[{fileid:string,filename:string,filesize:number}]',
                PRIMARY KEY (`id`)
            );

            -- 省市区表
            CREATE TABLE sys_pcd  (
                `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
                `remark` varchar(255) NULL COMMENT '备注',
                `update_time` datetime NULL COMMENT '更新时间',
                `delete_flag` tinyint(1) NULL COMMENT '删除标识，枚举',
                `type` int(1) NULL COMMENT '类型，枚举，省/市/区/街道/社区村/组号',
                `code` varchar(8) NULL COMMENT '编码code:唯一',
                `name` varchar(32) NULL COMMENT '名称',
                `parent_id` int NULL COMMENT '上级id',
                PRIMARY KEY (`id`)
            );

            -- 招生记录
            CREATE TABLE rs_recruit_record  (
                `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
                `remark` varchar(255) NULL COMMENT '备注',
                `update_time` datetime NULL COMMENT '更新时间',
                `delete_flag` tinyint(1) NULL COMMENT '删除标识，枚举',
                `name` varchar(32) NULL COMMENT '招生名称',
                `study_year_start` datetime NULL COMMENT '学年开始时间',
                `study_year_end` datetime NULL COMMENT '学年结束时间',
                `period_id` int NULL COMMENT '学段id',
                `period_code` int(1) NULL COMMENT '学段Code,枚举',
                `start_time` datetime NULL COMMENT '招生开始时间',
                `end_time` datetime NULL COMMENT '招生结束时间',
                `brief` text NULL COMMENT '招生简章，富文本',
                `tips` text NULL COMMENT '全局提示，逗号分隔',
                `tel` text NULL COMMENT '咨询电话，逗号分隔',
                `is_site` tinyint(1) NULL COMMENT '是否开启现场审核',
                `is_apply_check` tinyint(1) NULL COMMENT '教管中心报名是否需要教委审核',
                `is_adjust_check` tinyint(1) NULL COMMENT '教管中心调配是否需要教委审核',
                `exam_id` int NULL COMMENT '对应考试_id，高中时',
                `exam_name` int NULL COMMENT '对应考试名称，高中时',
                PRIMARY KEY (`id`)
            );

            -- 招生记录批次
            CREATE TABLE rs_recruit_record_batch  (
                `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
                `remark` varchar(255) NULL COMMENT '备注',
                `update_time` datetime NULL COMMENT '更新时间',
                `delete_flag` tinyint(1) NULL COMMENT '删除标识，枚举',
                `name` varchar(32) NULL COMMENT '批次名称',
                `start_time` datetime NULL COMMENT '批次开始时间',
                `end_time` datetime NULL COMMENT '批次结束时间',
                `apply_start_time` datetime NULL COMMENT '申报开始时间',
                `apply_end_time` datetime NULL COMMENT '申报结束时间',
                `check_start_time` datetime NULL COMMENT '审核开始时间',
                `check_end_time` datetime NULL COMMENT '审核结束时间',
                `admit_start_time` datetime NULL COMMENT '录取开始时间',
                `admit_end_time` datetime NULL COMMENT '录取结束时间',
                `period_batch_id` int NULL COMMENT '招生类型，rs_period_batch表的id',
                `admit_type` int(1) NULL COMMENT '录取方式，枚举',
                `description` varchar(255) NULL COMMENT '描述',
                `is_enabled_apply` tinyint(1) NULL COMMENT '用户是否可以填报',
                `is_apply_category` tinyint(1) NULL COMMENT '是否按照分类进行申报',
                `sort_no` int(2) NULL COMMENT '批次顺序，前端显示',
                PRIMARY KEY (`id`)
            );

            -- 招生记录批次兼报关系
            CREATE TABLE rs_recruit_record_togethor  (
                `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
                `target_id` int NULL COMMENT '兼报目标批次id',
                `source_id` int NULL COMMENT '当前批次id',
                PRIMARY KEY (`id`)
            );

            -- 招生记录批次流程控制
            CREATE TABLE rs_recruit_record_flow  (
                `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
                `recruit_record_batch_id` int NULL COMMENT '批次表id',
                `period_batch_id` int NULL COMMENT '学段批次表id',
                `remark` text NULL COMMENT '备注',
                `update_time` datetime NULL COMMENT '更新时间',
                `delete_flag` tinyint(1) NULL COMMENT '删除标识，枚举',
                `type` varchar(16) NULL COMMENT 'apply/check_online/check_site/admit\r\n填报/线上审核/现场审核/录取',
                `sort_no` int(2) NULL COMMENT '表单排序',
                `form_table` int NULL COMMENT '表单表',
                `form_design` text NULL COMMENT '表单设计内容/如果是录取为通知书模板',
                `name` varchar(32) NULL COMMENT '名称',
                `form_temp_id` int NULL COMMENT '临时表的id',
                `success` varchar(128) NULL COMMENT '成功模板',
                `failed` varchar(128) NULL COMMENT '失败模板',
                `notice_type` int(1) NULL COMMENT '推送方式，枚举',
                `is_allow_revoke` tinyint(1) NULL COMMENT '是否允许撤销',
                `is_need_confirm` tinyint(1) NULL COMMENT '是否需要确认',
                `status` int(1) NULL COMMENT '状态，枚举', 
                `is_enabled` tinyint(1) NULL COMMENT '是否填报内容',
                `is_adjust` tinyint(1) NULL COMMENT '是否开启调配',
                `fill_type` int(1) NULL COMMENT '填报内容类型,枚举',
                `fill_options` varchar(255) NULL COMMENT '填报内容下拉选项，逗号分隔',
                `unapply_batch_id` varchar(255) NULL COMMENT '不能兼报批次id,逗号分隔',
                `min` int(2) NULL COMMENT '必须填报的数量，默认为1',
                `max` int(2) NULL COMMENT '最多可以填报志愿的数量',
                PRIMARY KEY (`id`)
            );

            -- 流程对应的学校和专业
            CREATE TABLE rs_flow_school  (
                `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
                `update_time` datetime NULL COMMENT '更新时间',
                `delete_flag` tinyint(1) NULL COMMENT '删除标识，枚举',
                `org_id` int NULL COMMENT '学校的id',
                `org_name` varchar(16) NULL COMMENT '学校的名称，冗余字段',
                `flow_id` int NULL COMMENT 'rs_recruit_record_flow 的id',
                `profession_code` text NULL '专业Code,逗号分隔',
                `profession_name` text NULL '专业名称,逗号分隔',
                PRIMARY KEY (`id`)
            );

            -- 临时表
            CREATE TABLE re_recruit_record_form_temp  (
                `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
                `remark` text NULL COMMENT '备注',
                `update_time` datetime NULL COMMENT '更新时间',
                `delete_flag` tinyint(1) NULL COMMENT '删除标识，枚举',
                `field` varchar(16) NULL COMMENT '字段名称',
                `type` int(1) NULL COMMENT '字段类型',
                `description` varchar(64) NULL COMMENT '字段描述',
                `product` int(1) NULL COMMENT '产品，枚举',
                PRIMARY KEY (`id`)
            );

            -- 招生学校
            CREATE TABLE rs_recruit_record_school  (
                `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
                `remark` text NULL COMMENT '备注',
                `update_time` datetime NULL COMMENT '更新时间',
                `delete_flag` tinyint(1) NULL COMMENT '删除标识，枚举',
                `org_id` int NULL COMMENT '学校的id',
                `org_name` varchar(16) NULL COMMENT '学校的名称，冗余字段',
                `recruit_record_batch_id` int NULL COMMENT '招生批次id',
                `total` int(8) NULL COMMENT '计划招生人数',
                `is_total_once` tinyint(1) NULL COMMENT '是否共享招生人数',
                `is_share_plan` tinyint(1) NULL COMMENT '是否公开招生计划',
                `brief` text NULL COMMENT '招生简章',
                PRIMARY KEY (`id`)
            );

            -- 招生学校-专业
            CREATE TABLE rs_recruit_record_profession (
                `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
                `remark` text NULL COMMENT '备注',
                `update_time` datetime NULL COMMENT '更新时间',
                `delete_flag` tinyint(1) NULL COMMENT '删除标识，枚举',
                `recruit_record_batch_id` int NULL COMMENT '招生批次id',
                `count` int(8) NULL COMMENT '计划招生人数',
                `recruit_record_school_id` int NULL COMMENT '招生学校表rs_recruit_record_school的id',
                `code` varchar(8) NULL COMMENT '专业代码',
                `name` varchar(16) NULL COMMENT '专业名称',
                PRIMARY KEY (`id`)
            );

            -- 招生区域
            CREATE TABLE rs_recruit_record_area  (
                `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
                `remark` text NULL COMMENT '备注',
                `update_time` datetime NULL COMMENT '更新时间',
                `delete_flag` tinyint(1) NULL COMMENT '删除标识，枚举',
                `org_id` int NULL COMMENT '学校的id',
                `org_name` varchar(16) NULL COMMENT '学校的名称，冗余字段',
                `recruit_record_batch_id` int NULL COMMENT '招生批次id',
                `province` varchar(8) NULL COMMENT '省code',
                `province_name` varchar(16) NULL COMMENT '省名称',
                `city` varchar(8) NULL COMMENT '市code',
                `city_name` varchar(16) NULL COMMENT '市名称',
                `district` varchar(8) NULL COMMENT '区/县code',
                `district_name` varchar(16) NULL COMMENT '区/县名称',
                `town` varchar(8) NULL COMMENT '乡镇/街道code',
                `town_name` varchar(16) NULL COMMENT '乡镇/街道名称',
                `village` varchar(8) NULL COMMENT '社区/村code',
                `village_name` varchar(16) NULL COMMENT '社区/村名称',
                `group` varchar(8) NULL COMMENT '号，组，号code',
                `group_name` varchar(16) NULL COMMENT '号，组名称',
                `detail_address` varchar(64) NULL COMMENT '详细地址',
                `detail_type` int(1) NULL COMMENT '地址类型，枚举，城区，非城区',
                PRIMARY KEY (`id`)
            );

            -- 考试
            CREATE TABLE rs_exam  (
                `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
                `remark` text NULL COMMENT '备注',
                `update_time` datetime NULL COMMENT '更新时间',
                `delete_flag` tinyint(1) NULL COMMENT '删除标识，枚举',
                `name` varchar(16) NULL COMMENT '考试名称',
                `study_year_start` datetime NULL COMMENT '学年开始时间',
                `study_year_end` datetime NULL COMMENT '学年结束时间',
                `semester` int(1) NULL COMMENT '学期，枚举',
                `description` varchar(255) NULL COMMENT '描述',
                PRIMARY KEY (`id`)
            );

            


            


-- ------------SQL语句结束线-------------------
            CALL UPDATE_DB_VERSION(version);
        COMMIT;
    END IF;
END;
CALL DB_UPGRADE(1);
-- 1.0结束


-- 1.1开始
DROP  PROCEDURE  IF  EXISTS  DB_UPGRADE;
CREATE  PROCEDURE DB_UPGRADE(version float) 
BEGIN
    IF( GET_DB_VERSION() < version) THEN
-- ------------SQL语句起始线---------------
        


-- ------------SQL语句结束线-------------------
        CALL UPDATE_DB_VERSION(version);
    END IF;
END;
CALL DB_UPGRADE(1.1);
-- 1.1结束


-- ---------------------------------脚本结束区域------------------------------------------------------

-- ------------固定->清除过程和函数-----------------
DROP  PROCEDURE  IF  EXISTS  DB_UPGRADE;
DROP  PROCEDURE  IF  EXISTS  UPDATE_DB_VERSION;
DROP FUNCTION IF EXISTS GET_DB_VERSION;
DROP FUNCTION IF EXISTS TABLE_EXISTS;
$$$$$$
DELIMITER;