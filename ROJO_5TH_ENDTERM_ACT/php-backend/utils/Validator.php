<?php

class Validator {
    private static $errors = [];

    public static function validate($data, $rules) {
        self::$errors = [];

        foreach ($rules as $field => $fieldRules) {
            $value = $data[$field] ?? null;
            $ruleArray = explode('|', $fieldRules);

            foreach ($ruleArray as $rule) {
                self::checkRule($field, $value, $rule);
            }
        }

        return empty(self::$errors);
    }

    private static function checkRule($field, $value, $rule) {
        if (strpos($rule, ':') !== false) {
            [$ruleName, $ruleValue] = explode(':', $rule);
        } else {
            $ruleName = $rule;
            $ruleValue = null;
        }

        switch ($ruleName) {
            case 'required':
                if (empty($value)) {
                    self::$errors[$field][] = ucfirst($field) . ' is required';
                }
                break;

            case 'email':
                if ($value && !filter_var($value, FILTER_VALIDATE_EMAIL)) {
                    self::$errors[$field][] = ucfirst($field) . ' must be a valid email';
                }
                break;

            case 'min':
                if ($value && strlen($value) < $ruleValue) {
                    self::$errors[$field][] = ucfirst($field) . ' must be at least ' . $ruleValue . ' characters';
                }
                break;

            case 'max':
                if ($value && strlen($value) > $ruleValue) {
                    self::$errors[$field][] = ucfirst($field) . ' must not exceed ' . $ruleValue . ' characters';
                }
                break;

            case 'numeric':
                if ($value && !is_numeric($value)) {
                    self::$errors[$field][] = ucfirst($field) . ' must be numeric';
                }
                break;

            case 'unique':
                // Will be checked in model if needed
                break;

            case 'confirmed':
                // Password confirmation check
                break;
        }
    }

    public static function errors() {
        return self::$errors;
    }

    public static function hasErrors() {
        return !empty(self::$errors);
    }

    public static function getFirstError() {
        foreach (self::$errors as $field => $messages) {
            return $messages[0] ?? 'Validation error';
        }
        return null;
    }
}
