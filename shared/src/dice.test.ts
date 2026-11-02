import { describe, expect, it } from 'vitest';
import { CRITICAL_THRESHOLD, SUCCESS_THRESHOLD } from './dice.js';

describe('seuils du jet de réussite', () => {
  it('reprend les seuils des règles', () => {
    expect(SUCCESS_THRESHOLD).toBe(7);
    expect(CRITICAL_THRESHOLD).toBe(12);
  });
});
