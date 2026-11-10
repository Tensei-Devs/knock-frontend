// Spec 003, CA-02 y R-07: las reglas de frontera de ESLint fallan de verdad ante el código prohibido.
import assert from 'node:assert/strict';
import path from 'node:path';
import { test } from 'node:test';
import { fileURLToPath } from 'node:url';
import { ESLint } from 'eslint';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '../../..');
const eslint = new ESLint({ cwd: root });

async function lint(source, relativePath) {
  const [result] = await eslint.lintText(source, { filePath: path.join(root, relativePath) });
  return result.messages.filter((message) => message.severity === 2);
}

test('CA-003-02 a component that imports HttpClient fails the lint (CA-02)', async () => {
  const messages = await lint(
    `import { Component, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
@Component({ selector: 'app-x', template: '' })
export class XComponent { private readonly http = inject(HttpClient); }
`,
    'src/app/features/x/x.component.ts',
  );
  assert.ok(
    messages.some((m) => m.ruleId === 'no-restricted-imports'),
    JSON.stringify(messages),
  );
});

test('CA-003-02 a service may import HttpClient (CA-02)', async () => {
  const messages = await lint(
    `import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
@Injectable({ providedIn: 'root' })
export class XService { private readonly http = inject(HttpClient); }
`,
    'src/app/features/x/x.service.ts',
  );
  assert.equal(messages.filter((m) => m.ruleId === 'no-restricted-imports').length, 0);
});

// El nombre se compone con ${'Html'} a propósito: el texto de prueba no debe coincidir con la regla de Semgrep que prohíbe el nombre completo.
test('R-07 bypassSecurityTrust* and innerHTML in code fail the lint (R-07)', async () => {
  const messages = await lint(
    `export function render(sanitizer: { bypassSecurityTrust${'Html'}(v: string): unknown }, el: HTMLElement) {
  el.innerHTML = '<b>x</b>';
  return sanitizer.bypassSecurityTrust${'Html'}('x');
}
`,
    'src/app/shared/render.ts',
  );
  const restricted = messages
    .filter((m) => m.ruleId === 'no-restricted-syntax')
    .map((m) => m.message);
  assert.ok(
    restricted.some((m) => m.includes('innerHTML')),
    JSON.stringify(messages),
  );
  assert.ok(
    restricted.some((m) => m.includes('bypassSecurityTrust')),
    JSON.stringify(messages),
  );
});

test('R-07 [innerHTML] in a template fails the lint (R-07)', async () => {
  const messages = await lint(
    '<div [innerHTML]="html"></div>\n',
    'src/app/features/x/x.component.html',
  );
  assert.ok(
    messages.some((m) => m.ruleId === 'no-restricted-syntax'),
    JSON.stringify(messages),
  );
});
