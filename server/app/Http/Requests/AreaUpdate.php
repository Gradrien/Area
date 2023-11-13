<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class AreaUpdate extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'active' => 'required|boolean',
            'name' => 'required|string',
            'action_config' => 'required|json',
            'reaction_config' => 'required|json',
            'refresh' => 'required|integer',
        ];
    }
}
