import * as http from '@/utils/request'

export const delFile = (params) => http.dd('files?file=' + params.file);
export const importRest = (params) => http.post('rest', params)
export const saveRest = (params) => http.post('interface', params)
