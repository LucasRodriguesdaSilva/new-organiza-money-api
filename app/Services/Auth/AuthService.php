<?php

namespace App\Services\Auth;

use App\Http\Resources\UserResource;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class AuthService
{
    public function registrarUsuario(array $data): array
    {
        $user = User::create([
            'name' => $data['name'],
            'email' => $data['email'],
            'password' => Hash::make($data['password'])
        ]);

        $token = $user->createToken('auth_token')->plainTextToken;

        return [
            'message' => 'Usuário registrado com sucesso!',
            'data' => new UserResource($user),
            'access_token' => $token,
            'token_type' => 'Bearer'
        ];
    }
}