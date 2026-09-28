let products = [
  {
    id: 1,
    name: "Chordessa M7",
    brand: "STRUNOVA",
    category: "Strings",
    system: "Acoustic",
    price: 2850,
    stock: 7,
    image: "./Assets/Chordessa M7.png"
  },
  {
    id: 2,
    name: "Trevoraq IX",
    brand: "STRUNOVA",
    category: "Strings",
    system: "Hybrid",
    price: 4200,
    stock: 4,
    image: "./Assets/Trevoraq IX.png"
  },
  {
    id: 3,
    name: "Aureline S4",
    brand: "STRUNOVA",
    category: "Strings",
    system: "Acoustic",
    price: 2350,
    stock: 8,
    image: "./Assets/Aureline S4.png"
  },
  {
    id: 4,
    name: "Frelvyn Aeria",
    brand: "VELTRUNE",
    category: "Wind",
    system: "Hybrid",
    price: 3150,
    stock: 6,
    image: "./Assets/Frelvyn Aeria.png"
  },
  {
    id: 5,
    name: "Velnor Flute",
    brand: "VELTRUNE",
    category: "Wind",
    system: "Acoustic",
    price: 780,
    stock: 15,
    image: "./Assets/Velnor Flute.png"
  },
  {
    id: 6,
    name: "Sereen Flow",
    brand: "VELTRUNE",
    category: "Wind",
    system: "Acoustic",
    price: 1150,
    stock: 10,
    image: "./Assets/Sereen Flow.png"
  },
  {
    id: 7,
    name: "Sondryth Vale",
    brand: "ARQENZA",
    category: "Percussion",
    system: "Hybrid",
    price: 3750,
    stock: 5,
    image: "./Assets/Sondryth Vale.png"
  },
  {
    id: 8,
    name: "Solenne Arc",
    brand: "ARQENZA",
    category: "Strings",
    system: "Acoustic",
    price: 4950,
    stock: 3,
    image: "./Assets/Solenne Arc.png"
  },
  {
    id: 9,
    name: "Elaris Harp",
    brand: "ARQENZA",
    category: "Strings",
    system: "Acoustic",
    price: 5600,
    stock: 2,
    image: "./Assets/Elaris Harp.png"
  },
  {
    id: 10,
    name: "Cordynth Pulse",
    brand: "LYRAVEX",
    category: "Keyboard",
    system: "Hybrid",
    price: 4450,
    stock: 4,
    image: "./Assets/Cordynth Pulse.png"
  },
  {
    id: 11,
    name: "Orbis Resonator",
    brand: "LYRAVEX",
    category: "Percussion",
    system: "Acoustic",
    price: 1950,
    stock: 9,
    image: "./Assets/Orbis Resonator.png"
  },
  {
    id: 12,
    name: "Nomad Harmonic",
    brand: "LYRAVEX",
    category: "Experimental",
    system: "Electric",
    price: 3200,
    stock: 6,
    image: "./Assets/Nomad Harmonic.png"
  }
];

let cart = [];

const productGrid = document.getElementById("productGrid");
const searchInput = document.getElementById("searchInput");
const headerSearch = document.getElementById("headerSearch");
const brandFilter = document.getElementById("brandFilter");
const categoryFilter = document.getElementById("categoryFilter");
const systemFilter = document.getElementById("systemFilter");
const resetFilters = document.getElementById("resetFilters");
const productForm = document.getElementById("productForm");
const cartList = document.getElementById("cartList");
const cartBadge = document.getElementById("cartBadge");
const cartItemCount = document.getElementById("cartItemCount");
const cartTotal = document.getElementById("cartTotal");
const formMessage = document.getElementById("formMessage");

function formatPrice(price) {
  return `$${price.toFixed(0)}`;
}

function getFilteredProducts() {
  const searchValue = searchInput.value.toLowerCase();
  const selectedBrand = brandFilter.value;
  const selectedCategory = categoryFilter.value;
  const selectedSystem = systemFilter.value;

  return products.filter((product) => {
    const nameMatches = product.name.toLowerCase().includes(searchValue);
    const brandMatches = selectedBrand === "All" || product.brand === selectedBrand;
    const categoryMatches = selectedCategory === "All" || product.category === selectedCategory;
    const systemMatches = selectedSystem === "All" || product.system === selectedSystem;

    return nameMatches && brandMatches && categoryMatches && systemMatches;
  });
}

function createProductCard(product) {
  const { id, name, brand, category, system, price, stock, image } = product;

  const card = document.createElement("article");
  card.className = "product-card";

  const productImage = document.createElement("img");
  productImage.className = "product-card__image";
  productImage.src = image;
  productImage.alt = name;

  const body = document.createElement("div");
  body.className = "product-card__body";

  const brandText = document.createElement("p");
  brandText.className = "product-card__brand";
  brandText.textContent = brand;

  const title = document.createElement("h3");
  title.textContent = name;

  const meta = document.createElement("div");
  meta.className = "product-card__meta";

  const categoryText = document.createElement("span");
  categoryText.textContent = category;

  const systemText = document.createElement("span");
  systemText.textContent = system;

  meta.appendChild(categoryText);
  meta.appendChild(systemText);

  const information = document.createElement("div");
  information.className = "product-card__info";

  const priceText = document.createElement("strong");
  priceText.className = "product-card__price";
  priceText.textContent = formatPrice(price);

  const stockText = document.createElement("span");
  stockText.textContent = `Stock: ${stock}`;

  information.appendChild(priceText);
  information.appendChild(stockText);

  const actions = document.createElement("div");
  actions.className = "product-card__actions";

  const cartButton = document.createElement("button");
  cartButton.className = "add-cart-button";
  cartButton.type = "button";
  cartButton.textContent = "Add to Cart";

  const deleteButton = document.createElement("button");
  deleteButton.className = "delete-button";
  deleteButton.type = "button";
  deleteButton.textContent = "Remove";

  cartButton.addEventListener("click", () => {
    addToCart(id);
  });

  deleteButton.addEventListener("click", () => {
    deleteProduct(id);
  });

  actions.appendChild(cartButton);
  actions.appendChild(deleteButton);

  body.appendChild(brandText);
  body.appendChild(title);
  body.appendChild(meta);
  body.appendChild(information);
  body.appendChild(actions);

  card.appendChild(productImage);
  card.appendChild(body);

  return card;
}

function renderProducts() {
  productGrid.textContent = "";

  const filteredProducts = getFilteredProducts();

  if (filteredProducts.length === 0) {
    const message = document.createElement("p");
    message.className = "empty-message";
    message.textContent = "No instruments match these filters.";
    productGrid.appendChild(message);
    return;
  }

  filteredProducts.forEach((product) => {
    productGrid.appendChild(createProductCard(product));
  });
}

function updateStats() {
  const uniqueBrands = [];

  products.forEach((product) => {
    const brandExists = uniqueBrands.some((brand) => brand === product.brand);

    if (!brandExists) {
      uniqueBrands.push(product.brand);
    }
  });

  const totalStock = products.reduce((total, product) => total + product.stock, 0);
  const totalPrice = products.reduce((total, product) => total + product.price, 0);

  let averagePrice = 0;

  if (products.length > 0) {
    averagePrice = totalPrice / products.length;
  }

  const allProductsAvailable = products.every((product) => product.stock > 0);

  const statElements = {
    instruments: document.getElementById("statInstruments"),
    brands: document.getElementById("statBrands"),
    stock: document.getElementById("statStock"),
    average: document.getElementById("statAverage")
  };

  const statValues = {
    instruments: products.length,
    brands: uniqueBrands.length,
    stock: totalStock,
    average: formatPrice(averagePrice)
  };

  Object.keys(statElements).forEach((key) => {
    statElements[key].textContent = statValues[key];
  });

  const stockStatus = document.getElementById("stockStatus");

  if (allProductsAvailable) {
    stockStatus.textContent = "All instruments are currently available.";
  } else {
    stockStatus.textContent = "Some instruments are currently out of stock.";
  }
}

function addToCart(productId) {
  const product = products.find((product) => product.id === productId);

  if (!product) {
    return;
  }

  const productAlreadyExists = cart.some((item) => item.id === productId);

  if (productAlreadyExists) {
    cart = cart.map((item) => {
      if (item.id === productId) {
        return {
          ...item,
          quantity: item.quantity + 1
        };
      }

      return item;
    });
  } else {
    cart = [
      ...cart,
      {
        ...product,
        quantity: 1
      }
    ];
  }

  renderCart();
}

function removeFromCart(productId) {
  cart = cart.filter((item) => item.id !== productId);
  renderCart();
}

function renderCart() {
  cartList.textContent = "";

  if (cart.length === 0) {
    const message = document.createElement("p");
    message.className = "empty-message";
    message.textContent = "Your cart is empty.";
    cartList.appendChild(message);
  }

  cart.forEach((item) => {
    const { id, name, brand, price, quantity, image } = item;

    const cartItem = document.createElement("article");
    cartItem.className = "cart-item";

    const imageElement = document.createElement("img");
    imageElement.src = image;
    imageElement.alt = name;

    const textArea = document.createElement("div");

    const title = document.createElement("h3");
    title.textContent = name;

    const brandText = document.createElement("p");
    brandText.textContent = brand;

    textArea.appendChild(title);
    textArea.appendChild(brandText);

    const priceText = document.createElement("strong");
    priceText.textContent = `${quantity} × ${formatPrice(price)}`;

    const removeButton = document.createElement("button");
    removeButton.type = "button";
    removeButton.textContent = "Remove";

    removeButton.addEventListener("click", () => {
      removeFromCart(id);
    });

    cartItem.appendChild(imageElement);
    cartItem.appendChild(textArea);
    cartItem.appendChild(priceText);
    cartItem.appendChild(removeButton);

    cartList.appendChild(cartItem);
  });

  const totalItems = cart.reduce((total, item) => total + item.quantity, 0);
  const totalPrice = cart.reduce((total, item) => total + item.price * item.quantity, 0);

  cartItemCount.textContent = totalItems;
  cartBadge.textContent = totalItems;
  cartTotal.textContent = formatPrice(totalPrice);
}

function deleteProduct(productId) {
  products = products.filter((product) => product.id !== productId);
  cart = cart.filter((item) => item.id !== productId);

  renderProducts();
  renderCart();
  updateStats();
}

productForm.addEventListener("submit", (event) => {
  event.preventDefault();

  const name = document.getElementById("productName").value.trim();
  const brand = document.getElementById("productBrand").value;
  const category = document.getElementById("productCategory").value;
  const system = document.getElementById("productSystem").value;
  const price = Number(document.getElementById("productPrice").value);
  const stock = Number(document.getElementById("productStock").value);
  const image = document.getElementById("productImage").value.trim();

  const sameProductIndex = products.findIndex(
    (product) => product.name.toLowerCase() === name.toLowerCase()
  );

  if (sameProductIndex !== -1) {
    formMessage.textContent = "An instrument with this name already exists.";
    return;
  }

  const newProduct = {
    id: Date.now(),
    name,
    brand,
    category,
    system,
    price,
    stock,
    image
  };

  products = [...products, newProduct];

  productForm.reset();

  formMessage.textContent = `${name} was added to the collection.`;

  renderProducts();
  updateStats();
});

searchInput.addEventListener("input", () => {
  headerSearch.value = searchInput.value;
  renderProducts();
});

headerSearch.addEventListener("input", () => {
  searchInput.value = headerSearch.value;
  renderProducts();
});

brandFilter.addEventListener("change", renderProducts);
categoryFilter.addEventListener("change", renderProducts);
systemFilter.addEventListener("change", renderProducts);

resetFilters.addEventListener("click", () => {
  searchInput.value = "";
  headerSearch.value = "";
  brandFilter.value = "All";
  categoryFilter.value = "All";
  systemFilter.value = "All";

  renderProducts();
});

const brandCards = document.querySelectorAll(".brand-card");

brandCards.forEach((button) => {
  button.addEventListener("click", () => {
    brandFilter.value = button.value;

    renderProducts();

    document.getElementById("instruments").scrollIntoView();
  });
});

document.getElementById("categoryStrings").addEventListener("click", () => {
  categoryFilter.value = "Strings";
  systemFilter.value = "All";

  renderProducts();

  document.getElementById("instruments").scrollIntoView();
});

document.getElementById("categoryWind").addEventListener("click", () => {
  categoryFilter.value = "Wind";
  systemFilter.value = "All";

  renderProducts();

  document.getElementById("instruments").scrollIntoView();
});

document.getElementById("categoryHybrid").addEventListener("click", () => {
  categoryFilter.value = "All";
  systemFilter.value = "Hybrid";

  renderProducts();

  document.getElementById("instruments").scrollIntoView();
});

document.getElementById("categoryAcoustic").addEventListener("click", () => {
  categoryFilter.value = "All";
  systemFilter.value = "Acoustic";

  renderProducts();

  document.getElementById("instruments").scrollIntoView();
});

renderProducts();
renderCart();
updateStats();
