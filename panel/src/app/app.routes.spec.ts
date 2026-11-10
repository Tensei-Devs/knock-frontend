import { TestBed } from '@angular/core/testing';
import { provideRouter, Router } from '@angular/router';
import { RouterTestingHarness } from '@angular/router/testing';
import { routes } from './app.routes';
import { HomePageComponent } from './features/home/pages/home-page.component';

describe('panel routes', () => {
  beforeEach(() => {
    TestBed.configureTestingModule({ providers: [provideRouter(routes)] });
  });

  it('CA-003-03 declares every function as a lazy route and imports no page directly', () => {
    const lazy = routes.filter((route) => route.loadChildren || route.loadComponent);
    expect(lazy.length).toBeGreaterThan(0);
    expect(routes.every((route) => !route.component)).toBe(true);
  });

  it('CA-003-03 loads the home module when navigating to it', async () => {
    const harness = await RouterTestingHarness.create();

    const component = await harness.navigateByUrl('/', HomePageComponent);

    expect(component).toBeInstanceOf(HomePageComponent);
    expect(TestBed.inject(Router).url).toBe('/');
  });

  it('CA-003-03 sends an unknown path back to the start', async () => {
    const harness = await RouterTestingHarness.create();

    await harness.navigateByUrl('/no-existe');

    expect(TestBed.inject(Router).url).toBe('/');
  });
});
