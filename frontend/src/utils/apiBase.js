// Performance optimized | April 24, 2025
const rawBaseUrl = import.meta.env?.VITE_API_URL;

const normalizeBase = (value) => {
  if (!value || typeof value !== 'string') {
    return '';
  }

  const trimmed = value.trim();
  if (!trimmed || trimmed === '/') {
    return '';
  }

  return trimmed.replace(/\/+$/, '');
};

const isAbsoluteUrl = (path = '') => /^https?:\/\//i.test(path);

const API_BASE_URL = normalizeBase(rawBaseUrl);

export const buildApiUrl = (path = '') => {
  if (!path) {
    return API_BASE_URL || '';
  }

  if (isAbsoluteUrl(path)) {
    return path;
  }

  const normalizedPath = path.startsWith('/') ? path : `/${path}`;
  return API_BASE_URL ? `${API_BASE_URL}${normalizedPath}` : normalizedPath;
};

export const getApiBaseUrl = () => API_BASE_URL;


