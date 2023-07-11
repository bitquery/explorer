export const isNotEmptyArray = subj => Array.isArray(subj) && subj.length;

export const isNotEmptyObject = subj => !Array.isArray(subj) && typeof subj === 'object' && Object.keys(subj).length;

