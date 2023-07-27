<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="page-header">
    <!--=============== Navbar ===============-->
    <nav class="navbar fixed-top navbar-expand-md navbar-dark bg-transparent" id="page-navigation">
        <div class="container">
            <!-- Navbar Brand -->
            <a href="<%=request.getContextPath()%>/home.jsp" class="navbar-brand">
                <img src="<%=request.getContextPath()%>/resources/assets/img/logo/logo.png" alt="">
            </a>

            <!-- Toggle Button -->
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarcollapse" aria-controls="navbarCollapse" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarcollapse">
                <!-- Navbar Menu -->
                <ul class="navbar-nav ml-auto">
                    <li class="nav-item">
                        <a href="<%=request.getContextPath()%>/resources/shop.html" class="nav-link">Shop</a>
                    </li>
                    <li class="nav-item">
                        <a href="<%=request.getContextPath()%>/id_list/signUp.jsp" class="nav-link">Register</a>
                    </li>
                    <li class="nav-item">
                        <a href="<%=request.getContextPath()%>/id_list/login.jsp" class="nav-link active">Login</a>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="javascript:void(0)" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            <div class="avatar-header"><img src="<%=request.getContextPath()%>/resources/assets/img/logo/avatar.jpg"></div> John Doe
                        </a>
                        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                            <a class="dropdown-item" href="<%=request.getContextPath()%>/resources/transaction.html">My Page</a>
                            <a class="dropdown-item" href="<%=request.getContextPath()%>/resources/setting.html">Order List</a>
                            <a class="dropdown-item" href="<%=request.getContextPath()%>/id_list/logoutAction.jsp">Logout</a>
                        </div>
                      </li>
                    <li class="nav-item dropdown">
                        <a href="javascript:void(0)" class="nav-link dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            <i class="fa fa-shopping-basket"></i> <span class="badge badge-primary">5</span>
                        </a>
                        <div class="dropdown-menu shopping-cart">
                            <ul>
                                <li>
                                    <div class="drop-title">Your Cart</div>
                                </li>
                                <li>
                                    <div class="shopping-cart-list">
                                        <div class="media">
                                            <img class="d-flex mr-3" src="<%=request.getContextPath()%>/resources/assets/img/logo/avatar.jpg" width="60">
                                            <div class="media-body">
                                                <h5><a href="javascript:void(0)">Carrot</a></h5>
                                                <p class="price">
                                                    <span class="discount text-muted">Rp. 700.000</span>
                                                    <span>Rp. 100.000</span>
                                                </p>
                                                <p class="text-muted">Qty: 1</p>
                                            </div>
                                        </div>
                                        <div class="media">
                                            <img class="d-flex mr-3" src="<%=request.getContextPath()%>/resources/assets/img/logo/avatar.jpg" width="60">
                                            <div class="media-body">
                                                <h5><a href="javascript:void(0)">Carrot</a></h5>
                                                <p class="price">
                                                    <span class="discount text-muted">Rp. 700.000</span>
                                                    <span>Rp. 100.000</span>
                                                </p>
                                                <p class="text-muted">Qty: 1</p>
                                            </div>
                                        </div>
                                        <div class="media">
                                            <img class="d-flex mr-3" src="<%=request.getContextPath()%>/resources/assets/img/logo/avatar.jpg" width="60">
                                            <div class="media-body">
                                                <h5><a href="javascript:void(0)">Carrot</a></h5>
                                                <p class="price">
                                                    <span class="discount text-muted">Rp. 700.000</span>
                                                    <span>Rp. 100.000</span>
                                                </p>
                                                <p class="text-muted">Qty: 1</p>
                                            </div>
                                        </div>
                                        <div class="media">
                                            <img class="d-flex mr-3" src="<%=request.getContextPath()%>/resources/assets/img/logo/avatar.jpg" width="60">
                                            <div class="media-body">
                                                <h5><a href="javascript:void(0)">Carrot</a></h5>
                                                <p class="price">
                                                    <span class="discount text-muted">Rp. 700.000</span>
                                                    <span>Rp. 100.000</span>
                                                </p>
                                                <p class="text-muted">Qty: 1</p>
                                            </div>
                                        </div>
                                    </div>
                                </li>
                                <li>
                                    <div class="drop-title d-flex justify-content-between">
                                        <span>Total:</span>
                                        <span class="text-primary"><strong>Rp. 2000.000</strong></span>
                                    </div>
                                </li>
                                <li class="d-flex justify-content-between pl-3 pr-3 pt-3">
                                    <a href="<%=request.getContextPath()%>/resources/cart.html" class="btn btn-default">View Cart</a>
                                    <a href="<%=request.getContextPath()%>/resources/checkout.html" class="btn btn-primary">Checkout</a>
                                </li>
                            </ul>
                        </div>
                    </li>
                </ul>
            </div>

        </div>
    </nav>
</div>