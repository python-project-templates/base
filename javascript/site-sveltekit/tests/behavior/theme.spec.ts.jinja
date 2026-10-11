import { expect, test } from '@playwright/test';

test('theme selection persists across navigation', async ({ page }) => {
  await page.goto('/');
  await page.evaluate(() => localStorage.removeItem('theme'));
  await page.reload();

  const initial = await page.locator('html').getAttribute('data-theme');
  await page.getByTestId('theme-toggle').click();
  const expected = initial === 'dark' ? 'light' : 'dark';

  await expect(page.locator('html')).toHaveAttribute('data-theme', expected);
  await page.reload();
  await expect(page.locator('html')).toHaveAttribute('data-theme', expected);
});
