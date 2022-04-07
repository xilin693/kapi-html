import * as http from '@/utils/request'

export const getProjectEnv = (id) => http.get('/envs/' + id + '/project')
export const saveProjectEnv = (params) => http.post('/envs', params)
export const getEnvDetail = (params) => http.get('/envs/' + params.id)
export const updateEnv = (params) => http.put('/envs/' + params.id, params)
export const delEnv = (params) => http.dd('/envs/' + params.id)
