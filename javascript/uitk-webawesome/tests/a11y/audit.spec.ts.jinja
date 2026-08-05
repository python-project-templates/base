import AxeBuilder from '@axe-core/playwright';
import { expect, test } from '@playwright/test';

test('showcase has no serious or critical accessibility violations', async ({ page }) => {
  await page.goto('/');
  const results = await new AxeBuilder({ page }).withTags(['wcag2a', 'wcag2aa', 'wcag21a', 'wcag21aa']).analyze();
  const violations = results.violations.filter((violation) => ['serious', 'critical'].includes(violation.impact ?? ''));
  expect(violations).toEqual([]);
});
