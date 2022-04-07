import * as http from '@/utils/request'

export const getOwnerProject = () => http.get('/projects');
export const getCurrentProject = (id) => http.get('/projects/' + id);
export const getNavGroup = data => http.get('/projects/group', data);
export const getAllGroup = data => http.get('/projects/group/all', data);
export const getInviteProject = data => http.get('/projects/invite', data);
export const getGroupProject = (params) => http.get('/projects/' + params.id + '/group');
export const getProjectAccount = (params) => http.get('/projects/' + params.id + '/account');
export const saveProjectMember = (params) => http.post('/members/', params);
export const getProjectMember = (id, params) => http.get('/members/' + id + '/project',params);
export const updateProjectMember = (params) => http.put('/members/' + params.id, params);
export const saveProjectGroup = (params) => http.post('projects/', params);
export const updateProjectGroup = (params) => http.put('projects/' + params.id, params);
export const updateProjectProgress = (params) => http.put('projects/' + params.id + '/progress', params);
export const delProjectGroup = (params) => http.dd('projects/' + params.id);
export const saveProject = (params) => http.post('projects', params);
export const importProject = (params) => http.post('projects/json', params);
export const exportProject = (params) => http.post('projects/export', params);
export const getCurrentMember = (params) => http.get('/members/project', params);
export const getProjectOrganize = (params) => http.get('/projects/organize', params);
export const removeMember = (params)  => http.dd('members?account_id=' + params['account_id'] + '&project_id=' + params['project_id']);
