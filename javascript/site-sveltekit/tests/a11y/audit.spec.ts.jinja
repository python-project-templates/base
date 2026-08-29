import AxeBuilder from '@axe-core/playwright';
import { expect, test } from '@playwright/test';

const routes = ['/'];

for (const route of routes) {
  for (const theme of ['light', 'dark'] as const) {
    test(`${route} has no serious or critical accessibility violations in ${theme} mode`, async ({ page }) => {
      await page.emulateMedia({ reducedMotion: 'reduce' });
      await page.addInitScript((value) => localStorage.setItem('theme', value), theme);
      await page.goto(route);

      const results = await new AxeBuilder({ page }).withTags(['wcag2a', 'wcag2aa', 'wcag21a', 'wcag21aa']).analyze();
      const violations = results.violations.filter((violation) =>
        ['serious', 'critical'].includes(violation.impact ?? '')
      );

      expect(violations).toEqual([]);
    });
  }
}
