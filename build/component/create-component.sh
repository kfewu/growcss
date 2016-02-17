#!/usr/bin/env php
<?php

$sourceDirectory   = __DIR__.'/../../src/components';
$readmeTemplate    = __DIR__.'/README.md';
$indexTemplate     = __DIR__.'/index.html';
$elementTemplate   = __DIR__.'/example-element.html';
$gitignoreTemplate = __DIR__.'/.gitignore';
$bowerTemplate     = __DIR__.'/bower.json';

$dirs = glob($sourceDirectory.'/*', GLOB_ONLYDIR);

foreach ($dirs as $dir) {
    // extract part of the folder name
    $parts = explode('/', $dir);
    // set variables
    list($vendor, $name) = array_slice($parts, - 2);

    $componentsDir = $dir.'/';
    $readme        = $componentsDir.'/README.md';

    if (!file_exists($readme)) {

        // create folders
        $demoFolder = $componentsDir.'/demo';
        if (!is_dir($demoFolder)) {
          mkdir($demoFolder);
        }

        $testFolder = $componentsDir.'/test';
        if (!is_dir($testFolder)) {
          mkdir($testFolder);
        }

        $package = strtolower($vendor.'/'.$name);

        // get template
        $readmeContent          = file_get_contents($readmeTemplate);
        $bowerContent           = file_get_contents($bowerTemplate);
        $elementTemplateContent = file_get_contents($elementTemplate);

        // replace variables in template
        $replacements = [
            '@name'    => $name,
            '@vendor'  => $vendor,
            '@package' => $package,
        ];

        $readmeOutput          = str_replace(array_keys($replacements), array_values($replacements), $readmeContent);
        $bowerOutput           = str_replace(array_keys($replacements), array_values($replacements), $bowerContent);
        $elementTemplateOutput = str_replace(array_keys($replacements), array_values($replacements), $elementTemplateContent);

        // create readme and bower.json
        file_put_contents($readme, $readmeOutput);
        file_put_contents($componentsDir.'/bower.json', $bowerOutput);
        file_put_contents($componentsDir.'/'.$name.'-element.html', $elementTemplateOutput);

        // create empty files
        file_put_contents($componentsDir.'/'.$name.'.html', '');

        // copy needed files
        $indexFile = $componentsDir.'/index.html';
        if (!is_file($indexFile)) {
          copy($indexTemplate, $indexFile);
        }

        $testIndexFile = $componentsDir.'/test/index.html';
        if (!is_file($testIndexFile)) {
          copy($indexTemplate, $testIndexFile);
        }

        $demoIndexFile = $componentsDir.'/demo/index.html';
        if (!is_file($demoIndexFile)) {
          copy($indexTemplate, $demoIndexFile);
        }

        $gitignoreFile = $componentsDir.'/.gitignore';
        if (!is_file($gitignoreFile)) {
          copy($gitignoreTemplate, $gitignoreFile);
        }

        echo "Created {$package}\r\n";
    }
}
