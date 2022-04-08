/*
 Navicat Premium Data Transfer

 Source Server         : rm-7xvmoa0d1z6rq5i9b5o.mysql.rds.aliyuncs.com
 Source Server Type    : MySQL
 Source Server Version : 80018
 Source Host           : rm-7xvmoa0d1z6rq5i9b5o.mysql.rds.aliyuncs.com:3306
 Source Schema         : kapi

 Target Server Type    : MySQL
 Target Server Version : 80018
 File Encoding         : 65001

 Date: 08/04/2022 11:32:29
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for kpi
-- ----------------------------
DROP TABLE IF EXISTS `kpi`;
CREATE TABLE `kpi` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_id` mediumint(9) NOT NULL DEFAULT '0' COMMENT '用户id',
  `my_score` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '自评分数json',
  `my_score_sum` tinyint(4) NOT NULL DEFAULT '0' COMMENT '自评总分',
  `re_score` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '复评分数json',
  `re_score_sum` tinyint(4) NOT NULL DEFAULT '0' COMMENT '复评总分',
  `final_score` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '终评分数json',
  `final_score_sum` tinyint(4) NOT NULL DEFAULT '0' COMMENT '最终分',
  `re_account_id` mediumint(9) NOT NULL DEFAULT '0' COMMENT '复评人员id',
  `ctime` int(11) NOT NULL DEFAULT '0' COMMENT '填写月份',
  `grade` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '绩效评级',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of kpi
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for project
-- ----------------------------
DROP TABLE IF EXISTS `project`;
CREATE TABLE `project` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pid` int(11) NOT NULL DEFAULT '0' COMMENT '项目组',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '项目名称',
  `account_id` mediumint(9) NOT NULL DEFAULT '0' COMMENT '项目所有者id',
  `icon` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '图标',
  `sort` mediumint(9) NOT NULL DEFAULT '0' COMMENT '排序',
  `icon_color` char(7) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '#3d546f' COMMENT '图标颜色',
  `leader_id` mediumint(9) NOT NULL DEFAULT '0' COMMENT '项目经理id',
  `progress` tinyint(4) NOT NULL DEFAULT '0' COMMENT '项目进度',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0开发中,1已完成,2维护中,3规划中,-1已暂停',
  `version` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '1.0' COMMENT '版本号',
  `post_use_json` tinyint(4) NOT NULL DEFAULT '0' COMMENT '1使用json,0不使用',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='项目信息表';

-- ----------------------------
-- Records of project
-- ----------------------------
BEGIN;
INSERT INTO `project` (`id`, `pid`, `name`, `account_id`, `icon`, `sort`, `icon_color`, `leader_id`, `progress`, `status`, `version`, `post_use_json`) VALUES (7, 0, '个人空间', 0, '', 1, '', 0, 0, 0, '1.0', 0);
COMMIT;

-- ----------------------------
-- Table structure for project_account
-- ----------------------------
DROP TABLE IF EXISTS `project_account`;
CREATE TABLE `project_account` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_pid` int(11) NOT NULL DEFAULT '0' COMMENT '项目分类id',
  `project_id` int(11) NOT NULL DEFAULT '0' COMMENT '项目id',
  `account_id` int(11) NOT NULL DEFAULT '0' COMMENT '用户id',
  `group` tinyint(4) NOT NULL DEFAULT '3' COMMENT '权限组,1组长,2开发者,3访客',
  `env_id` int(11) NOT NULL DEFAULT '0' COMMENT '默认env_id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='项目与用户关系表';

-- ----------------------------
-- Records of project_account
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for project_api
-- ----------------------------
DROP TABLE IF EXISTS `project_api`;
CREATE TABLE `project_api` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL DEFAULT '0' COMMENT '项目id',
  `pid` int(11) NOT NULL DEFAULT '0' COMMENT '接口分类id,来源于字典',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '接口名称或分类名称',
  `method` enum('get','post','put','delete') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'get' COMMENT '请求类型',
  `uri` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '请求网址',
  `account_id` mediumint(9) NOT NULL DEFAULT '0' COMMENT '接口创建人id',
  `complete` tinyint(4) NOT NULL DEFAULT '0' COMMENT '1完成,0未完成',
  `path_data` json DEFAULT NULL COMMENT '网址参数',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  `post_type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '1 json,0form data',
  PRIMARY KEY (`id`),
  KEY `project_id` (`project_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='项目接口表';

-- ----------------------------
-- Records of project_api
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for project_api_detail
-- ----------------------------
DROP TABLE IF EXISTS `project_api_detail`;
CREATE TABLE `project_api_detail` (
  `api_id` int(11) NOT NULL,
  `header_data` json DEFAULT NULL COMMENT 'header参数',
  `query_data` json DEFAULT NULL COMMENT '查询参数',
  `form_data` json DEFAULT NULL COMMENT 'post参数',
  `put_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT 'put参数',
  `return_data` json DEFAULT NULL COMMENT '返回参数',
  `put_doc` json DEFAULT NULL COMMENT 'put文档',
  `comment` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '接口备注',
  `utime` int(11) NOT NULL DEFAULT '0' COMMENT '保存时间',
  `project_id` int(11) NOT NULL DEFAULT '0' COMMENT '项目id',
  `route_url` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`api_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of project_api_detail
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for project_env
-- ----------------------------
DROP TABLE IF EXISTS `project_env`;
CREATE TABLE `project_env` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL COMMENT '项目id',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '环境名称',
  `domain` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '域名',
  `private` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否私有,默认为是',
  `sort` smallint(6) NOT NULL DEFAULT '0' COMMENT '排序',
  `account_id` int(11) NOT NULL DEFAULT '0' COMMENT '创建者id',
  `url_prefix` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '网址前缀',
  `global_header` json DEFAULT NULL COMMENT '全局Header',
  `global_cookie` json DEFAULT NULL COMMENT '全局cookie',
  PRIMARY KEY (`id`),
  KEY `project_id` (`project_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of project_env
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for sys_permission
-- ----------------------------
DROP TABLE IF EXISTS `sys_permission`;
CREATE TABLE `sys_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '菜单id',
  `name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '菜单名称',
  `url` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '接口api地址',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态,0、未启用 1正常',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=92 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='后台菜单表';

-- ----------------------------
-- Records of sys_permission
-- ----------------------------
BEGIN;
INSERT INTO `sys_permission` VALUES (1, '', 'general/file', 1);
INSERT INTO `sys_permission` VALUES (2, '', 'general/rest', 1);
INSERT INTO `sys_permission` VALUES (3, '', 'general/interface', 1);
INSERT INTO `sys_permission` VALUES (4, '', 'general/delFile', 1);
INSERT INTO `sys_permission` VALUES (5, '', 'project/get?private=1', 1);
INSERT INTO `sys_permission` VALUES (6, '', 'general/index', 1);
INSERT INTO `sys_permission` VALUES (7, '', 'general/userInfo', 1);
INSERT INTO `sys_permission` VALUES (8, '', 'captcha/index', 1);
INSERT INTO `sys_permission` VALUES (9, '', 'login/index', 1);
INSERT INTO `sys_permission` VALUES (10, '', 'login/logout', 1);
INSERT INTO `sys_permission` VALUES (11, '', 'account/get', 1);
INSERT INTO `sys_permission` VALUES (12, '', 'account/add', 1);
INSERT INTO `sys_permission` VALUES (13, '', 'account/edit', 1);
INSERT INTO `sys_permission` VALUES (14, '', 'account/audit', 1);
INSERT INTO `sys_permission` VALUES (15, '', 'account/detail', 1);
INSERT INTO `sys_permission` VALUES (16, '', 'account/get/name', 1);
INSERT INTO `sys_permission` VALUES (17, '', 'account/get/audit', 1);
INSERT INTO `sys_permission` VALUES (18, '', 'account/delete', 1);
INSERT INTO `sys_permission` VALUES (19, '', 'account/alterPassword', 1);
INSERT INTO `sys_permission` VALUES (20, '', 'account/resetPassword', 1);
INSERT INTO `sys_permission` VALUES (21, '', 'menu/get', 1);
INSERT INTO `sys_permission` VALUES (22, '', 'menu/add', 1);
INSERT INTO `sys_permission` VALUES (23, '', 'menu/detail', 1);
INSERT INTO `sys_permission` VALUES (24, '', 'menu/edit', 1);
INSERT INTO `sys_permission` VALUES (25, '', 'kpi/add', 1);
INSERT INTO `sys_permission` VALUES (26, '', 'kpi/detail', 1);
INSERT INTO `sys_permission` VALUES (27, '', 'kpi/get', 1);
INSERT INTO `sys_permission` VALUES (28, '', 'kpi/me', 1);
INSERT INTO `sys_permission` VALUES (29, '', 'kpi/excel', 1);
INSERT INTO `sys_permission` VALUES (30, '', 'kpi/edit', 1);
INSERT INTO `sys_permission` VALUES (31, '', 'kpi/all', 1);
INSERT INTO `sys_permission` VALUES (32, '', 'member/add', 1);
INSERT INTO `sys_permission` VALUES (33, '', 'member/delete', 1);
INSERT INTO `sys_permission` VALUES (34, '', 'member/get', 1);
INSERT INTO `sys_permission` VALUES (35, '', 'member/edit', 1);
INSERT INTO `sys_permission` VALUES (36, '', 'member/project', 1);
INSERT INTO `sys_permission` VALUES (37, '', 'role/get', 1);
INSERT INTO `sys_permission` VALUES (38, '', 'role/add', 1);
INSERT INTO `sys_permission` VALUES (39, '', 'role/edit', 1);
INSERT INTO `sys_permission` VALUES (40, '', 'role/delete', 1);
INSERT INTO `sys_permission` VALUES (41, '', 'role/detail', 1);
INSERT INTO `sys_permission` VALUES (42, '', 'role/menu', 1);
INSERT INTO `sys_permission` VALUES (43, '', 'tag/get', 1);
INSERT INTO `sys_permission` VALUES (44, '', 'tag/add', 1);
INSERT INTO `sys_permission` VALUES (45, '', 'tag/edit', 1);
INSERT INTO `sys_permission` VALUES (46, '', 'tag/delete', 1);
INSERT INTO `sys_permission` VALUES (47, '', 'dict/add', 1);
INSERT INTO `sys_permission` VALUES (48, '', 'dict/edit', 1);
INSERT INTO `sys_permission` VALUES (49, '', 'dict/delete', 1);
INSERT INTO `sys_permission` VALUES (50, '', 'dict/get', 1);
INSERT INTO `sys_permission` VALUES (51, '', 'item/add', 1);
INSERT INTO `sys_permission` VALUES (52, '', 'item/edit', 1);
INSERT INTO `sys_permission` VALUES (53, '', 'item/delete', 1);
INSERT INTO `sys_permission` VALUES (54, '', 'dict/getTag', 1);
INSERT INTO `sys_permission` VALUES (55, '', 'project/get', 1);
INSERT INTO `sys_permission` VALUES (56, '', 'project/invite', 1);
INSERT INTO `sys_permission` VALUES (57, '', 'api/account', 1);
INSERT INTO `sys_permission` VALUES (58, '', 'project/invite', 1);
INSERT INTO `sys_permission` VALUES (59, '', 'project/group', 1);
INSERT INTO `sys_permission` VALUES (60, '', 'project/group/all', 1);
INSERT INTO `sys_permission` VALUES (61, '', 'project/organize', 1);
INSERT INTO `sys_permission` VALUES (62, '', 'project/add', 1);
INSERT INTO `sys_permission` VALUES (63, '', 'project/importJson', 1);
INSERT INTO `sys_permission` VALUES (64, '', 'project/export', 1);
INSERT INTO `sys_permission` VALUES (65, '', 'project/edit', 1);
INSERT INTO `sys_permission` VALUES (66, '', 'project/progress', 1);
INSERT INTO `sys_permission` VALUES (67, '', 'project/delete', 1);
INSERT INTO `sys_permission` VALUES (68, '', 'project/detail', 1);
INSERT INTO `sys_permission` VALUES (69, '', 'api/search', 1);
INSERT INTO `sys_permission` VALUES (70, '', 'api/get', 1);
INSERT INTO `sys_permission` VALUES (71, '', 'api/detail', 1);
INSERT INTO `sys_permission` VALUES (72, '', 'api/project', 1);
INSERT INTO `sys_permission` VALUES (73, '', 'api/relative', 1);
INSERT INTO `sys_permission` VALUES (74, '', 'api/copyRelative', 1);
INSERT INTO `sys_permission` VALUES (75, '', 'api/sort', 1);
INSERT INTO `sys_permission` VALUES (76, '', 'api/category', 1);
INSERT INTO `sys_permission` VALUES (77, '', 'api/add', 1);
INSERT INTO `sys_permission` VALUES (78, '', 'api/saveCategory', 1);
INSERT INTO `sys_permission` VALUES (79, '', 'api/copy', 1);
INSERT INTO `sys_permission` VALUES (80, '', 'api/saveDetail', 1);
INSERT INTO `sys_permission` VALUES (81, '', 'api/json', 1);
INSERT INTO `sys_permission` VALUES (82, '', 'api/setField', 1);
INSERT INTO `sys_permission` VALUES (83, '', 'api/edit', 1);
INSERT INTO `sys_permission` VALUES (84, '', 'api/run', 1);
INSERT INTO `sys_permission` VALUES (85, '', 'api/delete', 1);
INSERT INTO `sys_permission` VALUES (86, '', 'env/get', 1);
INSERT INTO `sys_permission` VALUES (87, '', 'env/project', 1);
INSERT INTO `sys_permission` VALUES (88, '', 'env/add', 1);
INSERT INTO `sys_permission` VALUES (89, '', 'env/edit', 1);
INSERT INTO `sys_permission` VALUES (90, '', 'env/delete', 1);
INSERT INTO `sys_permission` VALUES (91, '', 'env/detail', 1);
COMMIT;

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '角色名',
  `permission_ids` json NOT NULL COMMENT '菜单id列表',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态 -1禁用,1启用',
  `create_time` int(11) NOT NULL DEFAULT '0',
  `update_time` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='管理员角色表';

-- ----------------------------
-- Records of sys_role
-- ----------------------------
BEGIN;
INSERT INTO `sys_role` VALUES (1, '普通用户', '[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 15, 19, 20, 25, 26, 27, 28, 32, 33, 34, 35, 36, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 61, 62, 63, 64, 65, 66, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91]', 1, 0, 0);
COMMIT;

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '',
  `password` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '',
  `realname` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '真实姓名',
  `avatar` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '',
  `create_time` int(11) NOT NULL DEFAULT '0',
  `role_ids` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '角色id',
  `last_login_time` int(11) NOT NULL DEFAULT '0' COMMENT '最后登录时间',
  `audit` tinyint(4) NOT NULL DEFAULT '0' COMMENT '1审核通过,0未审核,-1审核未通过',
  `admin` tinyint(4) NOT NULL DEFAULT '0',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '1 启用',
  PRIMARY KEY (`id`),
  KEY `audit` (`audit`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='管理员表';

-- ----------------------------
-- Records of sys_user
-- ----------------------------
BEGIN;
INSERT INTO `sys_user` VALUES (1, 'admin', 'eb3939d88693cb8097fe4683b4abfccb', '超级管理员', '2.jpg', 1580977735, '1', 347, 1, 1, 1);
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
