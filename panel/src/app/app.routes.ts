import { Routes } from '@angular/router';

/** Cada función del panel se carga bajo demanda; no se importa ninguna página de forma directa. */
export const routes: Routes = [
  {
    path: '',
    loadChildren: () => import('./features/home/home.routes').then((module) => module.HOME_ROUTES),
  },
  { path: '**', redirectTo: '' },
];
