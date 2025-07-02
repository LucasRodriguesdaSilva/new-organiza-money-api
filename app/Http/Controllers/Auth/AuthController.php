<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\RegisterRequest;
use App\Services\Auth\AuthService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class AuthController extends Controller
{
    public function __construct(protected AuthService $authService) {}

    public function store(RegisterRequest $request): JsonResponse
    {
        DB::beginTransaction();
        try {

            $result = $this->authService->registrarUsuario($request->validated());
            DB::commit();

            return response()->json($result, Response::HTTP_CREATED);
        } catch (\Exception $e) {
            DB::rollBack();
            Log::error('Erro no registro de usuário: ' . $e->getMessage());

            return response()->json([
                'message' => 'Ocorreu um erro interno no servidor. Por favor, tente novamente mais tarde'
            ], Response::HTTP_INTERNAL_SERVER_ERROR);
        }
    }
}
