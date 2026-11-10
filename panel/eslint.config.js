// @ts-check
const eslint = require('@eslint/js');
const { defineConfig } = require('eslint/config');
const tseslint = require('typescript-eslint');
const angular = require('angular-eslint');

module.exports = defineConfig([
  {
    files: ['**/*.ts'],
    extends: [
      eslint.configs.recommended,
      tseslint.configs.recommended,
      tseslint.configs.stylistic,
      angular.configs.tsRecommended,
    ],
    processor: angular.processInlineTemplates,
    rules: {
      '@angular-eslint/directive-selector': [
        'error',
        {
          type: 'attribute',
          prefix: 'app',
          style: 'camelCase',
        },
      ],
      '@angular-eslint/component-selector': [
        'error',
        {
          type: 'element',
          prefix: 'app',
          style: 'kebab-case',
        },
      ],
    },
  },
  {
    // Spec 003, R-04: los componentes no usan HttpClient; lo hacen los servicios.
    files: ['src/**/*.ts'],
    ignores: [
      'src/**/*.service.ts',
      'src/**/*.interceptor.ts',
      'src/app/app.config.ts',
      'src/**/*.spec.ts',
    ],
    rules: {
      'no-restricted-imports': [
        'error',
        {
          paths: [
            {
              name: '@angular/common/http',
              message: 'Los componentes no usan HttpClient (spec 003, R-04): inyecta un servicio.',
            },
          ],
        },
      ],
    },
  },
  {
    // Spec 003, R-07: nada de saltarse el saneado de Angular sin revisión.
    files: ['src/**/*.ts'],
    ignores: ['src/**/*.spec.ts'],
    rules: {
      'no-restricted-syntax': [
        'error',
        {
          selector: 'Identifier[name=/^bypassSecurityTrust/]',
          message: 'bypassSecurityTrust* está prohibido sin revisión (spec 003, R-07).',
        },
        {
          selector: "MemberExpression[property.name='innerHTML']",
          message: 'innerHTML está prohibido (spec 003, R-07).',
        },
      ],
    },
  },
  {
    files: ['**/*.html'],
    extends: [angular.configs.templateRecommended, angular.configs.templateAccessibility],
    rules: {
      'no-restricted-syntax': [
        'error',
        {
          selector: "BoundAttribute[name='innerHTML'], TextAttribute[name='innerHTML']",
          message: 'innerHTML está prohibido en las plantillas (spec 003, R-07).',
        },
      ],
    },
  },
]);
