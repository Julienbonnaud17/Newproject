<?php

namespace App\Controller\Api\V1;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\Routing\RouterInterface;

#[Route('/api/v1')]
class MainController extends AbstractController
{
    /**
     * Route qui retourne la liste les routes de l api
     * @return array $listApiRoutes
     * @return int code HTTP
     * @return JsonResponse {$listApiRoutes, code HTTP}
     */
    #[Route('/', name: 'api_index', methods:"GET", options:[
        'utility'       =>  'liste des routes de l api',
        'tokenRequired'       =>  false
    ])]
    public function index(RouterInterface $router): JsonResponse
    {
        $allRoutes = $router->getRouteCollection()->all();
        $listApiRoutes = [];
        foreach ($allRoutes as $actualRoute => $actualRouteParam) {
            $isApiRoute = preg_match('/\/api\/v1/', $actualRouteParam->getPath());
            if ($isApiRoute) {
                $listApiRoutes[$actualRoute] =  [
                    'utility' => $actualRouteParam->getOption('utility'),
                    'methods' => $actualRouteParam->getMethods(),
                    'path' => $actualRouteParam->getPath(),
                    'tokenRequired' => $actualRouteParam->getOption('tokenRequired'),
                ];
            }
        }
        return $this->json($listApiRoutes, 200);
    }

}
