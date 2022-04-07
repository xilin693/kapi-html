import * as http from '@/utils/request'

export const saveKpi = (params) => http.post('/kpis', params);
export const getKpi = (params) => http.get('/kpis/' + params.id);
export const exportExcel = (params) => http.get('/kpis/excel?month=' + params.month);
export const updateKpi = (params) => http.put('/kpis/',params);
export const getMyKpi = (params) => http.get('/kpis/me', params);
export const getAllKpi = (params) => http.get('/kpis', params);
export const saveAllKpi = (params) => http.post('/kpis/all', params);
